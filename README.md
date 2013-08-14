imagetools
==========

Tools for creating SmartOS images.

### Creating seed images

Seed images are the absolute baseline of a SmartOS image.  They are created
from files produced by a smartos-live build, containing the original `/etc`,
`/var` and SMF manifest database.

First, you need to perform a smartos-live build, as described in the wiki
page:

  http://wiki.smartos.org/display/DOC/Building+SmartOS+on+SmartOS

Then from the global zone:

    $ ./create-seed /path/to/smartos-live seed-image

This will create a `zones/seed-image` file system containing the seed files.

To create a SNGL seed, you will then need to extract a bootstrap tarball over
the top to populate enough of `/usr` for the zone to boot.  I tend to use our
pbulk pkgsrc bootstrap for this, for example:

    $ ./create-seed /path/to/smartos-live seed-sngl
    $ gtar -zxf /path/to/bootstrap-2013Q2-sngl.tar.gz -C /zones/seed-sngl/root/

Once you have a seed file system ready, use `create-image` to turn it into a
provisionable image and manifest.

    $ ./create-image seed-1.0 seed-image
    Enter your username: jperkin
    Enter your user UUID (leave empty to create one): d9d9dd4b-3011-4a45-bffe-ddc9ba4be2d2
    Enter description: Seed Image

This will use `/zones/seed-image`, snapshot it, and create a file system image
along with a manifest file ready for importing with `imgadm`.  Give it your
user credentials (or just make some up) and a useful description when
prompted.

Once complete it will output an `imgadm` command you can use, e.g.

    Done.  Now run this to install the image:
    
      imgadm install -m ./output/seed-1.0.json -f ./output/seed-1.0.zfs.gz

You can then use the UUID as input for the next phase.

### Creating base images

Base images are comprised of a baseline seed image, plus an applied overlay
appropriate for the target image.  You use the `install-image` tool to copy
the overlay files into a specified zone and then execute the customize script.

So, again using the `2013Q2-sngl` image as an example, start by creating a
basic zone based on the seed image created above (replacing `image_uuid` with
the uuid of the seed image):

    $ vmadm create <<EOF
    {
      "brand": "sngl",
      "image_uuid": "05d41bca-03f8-11e3-9064-c359e89c4139",
      "max_physical_memory": 512,
      "nics": [
        {
          "nic_tag": "admin",
          "ip": "dhcp"
        }
      ]
    }
    EOF
    Successfully created VM c374c4bc-2395-4848-b28d-0c18937e7775

Then we can apply the `2013Q2-sngl` configuration to the VM with:

    $ ./install-base 2013Q2-sngl c374c4bc-2395-4848-b28d-0c18937e7775

The final part of this script runs `sm-prepare-image` which does some final
image cleanup and shutdown, after which you can simply generate the finished
image, again with `create-image`:

    $ ./create-image sngl-13.2.0 c374c4bc-2395-4848-b28d-0c18937e7775
    Enter your username: jperkin
    Enter your user UUID (leave empty to create one): d9d9dd4b-3011-4a45-bffe-ddc9ba4be2d2
    Enter description: A multiarch SmartOS image utilising a GNU/Linux layout.

This final image and manifest should now be suitable for production use.
