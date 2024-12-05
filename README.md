# SiteReady v1.02
SENG 480A Startup Programming project repository. SiteReady - bridging the construction communication gap between office and worksite.

The **Project Page** can be found [here](https://sitereadycommunication.wordpress.com/).

A **Live Demo** can be found [here](https://broondoon.github.io/siteready_demopage/).

**Looking for deliverables?** Check out [the Wiki for this project](https://github.com/Broondoon/build-stats/wiki)

---

**How to Run:**
To run our DEMO, run 'make demo' from the root folder of the project.
This requires a windows operating system setup. Due to the server being locally hosted to avoid hosting costs (and because we couldn't figure out how to run flutter through docker), we have no way to demo the app properly on android. 
This should set everything up. 
You might need to download Flutter? Unsure.

Requirements:
- Git
- Visual Studio (*Not* VS Code!) with the "Desktop development with C++" package installed

Follow [these instructions](https://docs.flutter.dev/get-started/install) to download and install the Flutter SDK, and follow the `flutter doctor` to ensure your environment has everything it needs.

Once everything is set, just open the project in VS Code or any editor, navigate to `main.dart` and run the file. Alternatively, run the command `flutter run` in CMD.


---

**Licensing**

All rights reserved. This code may not be copied, modified, or distributed without permission.

Server files altered from https://github.com/dart-lang/samples/tree/main/server/simple by Dart DevRel
See lisence in Server/Documentation_From_Server_Source/License.txt.

**AI Usage**
Chat GPT was used to generate test cases and mock files for shared, server, and app, though hand altered to actually work properly and test all resources.
Chat GPT used extensively to help debug and advise, too many instances to really track. However, it was not really used to generate actual implemented production level code, besides as an advisor and idea/algorithm assistant. 
Copilot used throughout as part of just general programming (I.E quick fill and auto fill, but not really text exchange.)
Additionally, AI was used to help refine the Makefile to run the demo of the product. 
