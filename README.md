# Vtrack

[Vtrack](http://vtrack.hg.lan) is a Rails 4.1.4 application for tracking hourly activity in a
volunteer work setting.

## Origin

Written for the Recyclery Collective to keep track of volunteer hours.

## Todo

* Integrate scheduled Events with the hourly records

## Documentation

Vtrack is extensively documented via the [YARD](http://yardoc.org/) documentation tool. Additional documentation is also stored in the ```wiki/``` directory to reduce root directory clutter, and can't be accessed by GitHub's documentation generator, so some links on this page may not work. To access full documentation, clone the repository, install the gems, and type

```
bundle exec yard
```

into the root directory. Documentation based on this README can then be accessed at ```{RAILS_ROOT}/doc/index.html```

## Backup

See [Backup](file.BACKUP.html)

## How to run the test suite

See [Testing](file.TESTING.html#How_to_run_the_test_suite)

## Documentation

Code is documented using [YARD](http://yardoc.org/) syntax. YARD can be installed as a gem:

```
sudo gem install yard
```

To generate web documentation, run the ```yard``` command in the application's
root directory (the directory where this file is located).

Long-form documentation is kept in the ```wiki/``` directory, and while it is
not visible on GitHub, is visible in the generated documentation.
 
