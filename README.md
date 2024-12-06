# SiteReady v1.02
SENG 480A Startup Programming project repository. SiteReady - bridging the construction communication gap between office and worksite.

The **Project Page** can be found [here](https://sitereadycommunication.wordpress.com/).

A **Live Demo** can be found [here](https://broondoon.github.io/siteready_demopage/), although MAKE NOTE that it is without the server backend, and will likely malfunction. It is recommended to follow the steps described in How to Run instead.

**Looking for deliverables?** Check out [the Wiki for this project](https://github.com/Broondoon/build-stats/wiki)

---

**How to Run:**
Due to the server being locally hosted to avoid hosting costs (and numerous build crashes with using Docker), we have no way to demo the app with complete functionality on android, iOS or web. The following instructions are for how to host the complete app on a Linux or Windows computer.

Requirements:
- Git
- Visual Studio (*Not* VS Code!) with the "Desktop development with C++" package installed

Follow [these instructions](https://docs.flutter.dev/get-started/install) to download and install the Flutter SDK, and follow the `flutter doctor` to ensure your environment has everything it needs.

1. Download and install the .exe from the GitHub releases section of this repo.
2. Clone this repo onto your local machine.
3. In the command line, run `make demo` from the root folder of the project to build and start running the server.
4. Open the .exe to start running the app.

---

**Licensing**

All rights reserved. This code may not be copied, modified, or distributed without permission.

Server files altered from https://github.com/dart-lang/samples/tree/main/server/simple by Dart DevRel
See their lisence in /Server/Documentation_From_Server_Source/License.txt.

**AI Usage**
Chat GPT was used to generate test cases and mock files for shared, server, and app, though hand altered to actually work properly and test all resources.
Chat GPT used extensively to help debug and advise, too many instances to really track. However, it was not really used to generate actual implemented production level code, besides as an advisor and idea/algorithm assistant. 
Copilot used throughout as part of just general programming (I.E quick fill and auto fill, but not really text exchange.)
Additionally, AI was used to help refine the Makefile to run the demo of the product. 
