## How to use

Basically clone the repository and just do:
```docker compose up -d```

You can check if the Server is running by using:
```docker compose logs -f```

This is how it looks if it worked:
![image](https://github.com/Oucori/palworld-docker/assets/7293242/0b2bf92c-f9c2-4006-b168-1b98b2854834)


## How to Configurate
Composing the Docker will create a server folder.

### Copy the DefaultConfiguration to your Configuration
Copy from `server/DefaultPalWorldSettings.ini` to `server/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini`
Then you can edit `server/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini` to fit your needs.
