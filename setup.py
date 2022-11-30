try:
    from setuptools import setup
except:
    from distutils.core import setup


def parse_version(fname):
    version = ""
    with open(fname) as f:
        for line in f:
            if line.startswith("VERSION="):
                version = eval(line.strip().replace("VERSION=", ""))
                break
    assert version, "Can't find version string in ptimeout script"
    return version


setup(
    name="ptimeout",
    version=parse_version("ptimeout"),
    description="Simple and interruptible timeout tool",
    author="Christophe Guillon",
    license="GPLv2",
    url="https://github.com/guillon/ptimeout",
    long_description=open("README").read(),
    long_description_content_type='text/markdown',
    scripts=["ptimeout"],
    classifiers=[
        'Development Status :: 5 - Production/Stable',
        'Environment :: Console',
        'Intended Audience :: Developers',
        'License :: Public Domain',
        'Operating System :: POSIX :: Linux',
        'Programming Language :: Python :: 2.6',
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3.4',
        'Programming Language :: Python :: 3.5',
        'Programming Language :: Python :: 3.6',
        'Programming Language :: Python :: 3.7',
        'Programming Language :: Python :: 3.8',
        'Programming Language :: Python :: 3.9',
        'Programming Language :: Python :: 3.10',
        'Topic :: System :: Shells',
    ],
    zip_safe=True,
)
