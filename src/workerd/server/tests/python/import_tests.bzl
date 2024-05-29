load("@bazel_skylib//rules:write_file.bzl", "write_file")
load("//:build/wd_test.bzl", "wd_test")

def generate_import_py_file(imports):
  res = "def test():\n"
  for imp in imports:
    res += "   import "+imp+"\n"
  return res

WD_FILE_TEMPLATE = """
using Workerd = import "/workerd/workerd.capnp";

const unitTests :Workerd.Config = (
  services = [
    ( name = "python-import-{}",
      worker = (
        modules = [
          (name = "worker.py", pythonModule = embed "./worker.py"),
          (name = "{}", pythonRequirement = ""),
        ],
        compatibilityDate = "2024-05-02",
        compatibilityFlags = ["python_workers"],
      )
    ),
  ],
);"""

def generate_wd_test_file(requirement):
  return WD_FILE_TEMPLATE.format(requirement, requirement)

# to_test is a dictionary from library name to list of imports
def gen_import_tests(to_test):
  for lib in to_test.keys():
    worker_py_fname = "import/{}/worker.py".format(lib)
    wd_test_fname = "import/{}/import.wd-test".format(lib)
    write_file(worker_py_fname + "@rule",
      worker_py_fname,
      [generate_import_py_file(to_test[lib])])
    write_file(wd_test_fname + "@rule",
      wd_test_fname,
      [generate_wd_test_file(lib)])

    wd_test(
      src = "import/{}/import.wd-test".format(lib),
      args = ["--experimental", "--disk-cache-dir", "../all_pyodide_wheels"],
      data = [worker_py_fname, "@all_pyodide_wheels//:whls"],
      tags = ["linux-nondebug-only"]
    )