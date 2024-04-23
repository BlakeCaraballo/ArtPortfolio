# chat boards

## Configure firebase

- Visit https://firebase.google.com/docs/flutter/setup?platform=android#available-plugins
  - install flutterfire cli tools
  - instal firebase cli tools
  - login int you firebase account using firebase cli tool `firebase login`

Note: if you encounter an error link this

```
Warning: Pub installs executables into $HOME/.pub-cache/bin, which is not on your path.
You can fix that by adding this to your shell's config file (.bashrc, .bash_profile, etc.):

  export PATH="$PATH":"$HOME/.pub-cache/bin"

Activated flutterfire_cli 0.2.7.
```

when installing firabase fire, run the command `export PATH="$PATH":"$HOME/.pub-cache/bin"`

- run `flutterfire configure` to configure firebase

## Create firebase collections

- Open firebase console and navigate to your new created project
- Under products, click `Firestore Database`
- Create `profiles` and `arwork` collections
- Click the rules tab and allow read and write to true

```bash
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

## Setup Firebase Authentication

- From firebase product list. Select Firebase authentication
- Proceed and enable password/email sign in

## Setup Firebase storage

- From firebase product list, select Storage
- Setup storage and enable read/write as we did on collections

## Once the above task as successfull

- Run the flutter app with `flutter run`
