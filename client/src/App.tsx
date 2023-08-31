import { useState, useEffect } from 'react';
import { Box, LinearProgress, Typography, Grid, useTheme, useMediaQuery } from '@mui/material';
import { createDockerDesktopClient } from '@docker/extension-api-client';

const client = createDockerDesktopClient();

function useDockerDesktopClient() {
  return client;
}

export function App() {
  const [ready, setReady] = useState(false);
  const [unavailable, setUnavailable] = useState(false);
  const ddClient = useDockerDesktopClient();
  const isDarkModeEnabled = useMediaQuery('(prefers-color-scheme: dark)', { noSsr: true });

  useEffect(() => {
    let timer: number;
    let shCmd = '"sed -i s/'.concat((isDarkModeEnabled) ? 'Light' : 'Dark').concat('/').concat((isDarkModeEnabled) ? 'Dark' : 'Light').concat('/g /home/coder/.local/share/code-server/User/settings.json || echo \'{\\"workbench.colorTheme\\": \\"Default Light Modern\\"}\' > /home/coder/.local/share/code-server/User/settings.json"')
    //console.log(shCmd);
    const start = async () => {
      setReady(() => false);

      await ddClient.docker.cli.exec("exec", [
        '-d',
        'coder_embedded_dd_vm',
        '/bin/sh',
        '-c',
        shCmd
      ]);
      ddClient.docker.cli.exec("exec", [
        '-d',
        '--user',
        'root',
        'coder_embedded_dd_vm',
        'chgrp',
        '1000',
        '/var/run/docker.sock'
      ]);
    };

    start().then(() => {
      let retries = 60;
      let timer = setInterval(async () => {

        if (retries == 0) {
          clearInterval(timer);
          setUnavailable(true);
        }

        try {
          const result = await ddClient.extension.vm?.service?.get('/ready');

          if (Boolean(result)) {
            setReady(() => true);
            clearInterval(timer);
          }
        } catch (error) {
          console.log('error when checking VS Code Web status', error);
          retries--;
        }
      }, 1000);
    }).catch(error => {
      console.log('failed to start VS Code Web', error);
      ddClient.desktopUI.toast.error(error);
      setUnavailable(true);
    })

    return () => {
      clearInterval(timer);
    };
  }, [isDarkModeEnabled]);

  return (
    <>
      {unavailable && (
        <Grid container flex={1} direction="column" padding="16px 32px" height="100%" justifyContent="center" alignItems="center">
          <Grid item>
            VS Code Web failed to start, please close the extension and reopen/reinstall to try again.
          </Grid>
        </Grid>
      )}
      {!ready && (
        <Grid container flex={1} direction="column" padding="16px 32px" height="100%" justifyContent="center" alignItems="center">
          <Grid item>
            <LinearProgress/>
            <Typography mt={2}>
              Waiting for VS Code Web to be ready. It may take some seconds if
              it's the first time.
            </Typography>
          </Grid>
        </Grid>
      )}
      {ready && (
        <Box display="flex" flex={1} width="100%" height="100%">
          <iframe src='http://localhost:57080/' width="100%" height="100%" />
        </Box>
      )}
    </>
  );
}
