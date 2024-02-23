from extract_version import version_info
import glob
import os
with open("requirements.txt", "w") as file1:
    for dist in glob.glob(os.path.join("dist","*.tar.gz")):
        ver = version_info.extract_version(version_string=dist)
        name = os.path.basename(os.path.realpath(dist))
        if ver:
            name = name.split("-"+ver)[0]
            file1.write(f"{name}=={ver}\n")
