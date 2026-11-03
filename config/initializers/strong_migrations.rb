# Everything up to and including this version predates the gem. Without the
# marker strong_migrations re-checks the whole history, so old migrations become
# a tripwire for anyone rebuilding a database from scratch.
StrongMigrations.start_after = 20_241_004_100_359

# Lets the gem tell which operations are safe on the version we actually run,
# instead of assuming the oldest supported one.
StrongMigrations.target_version = '16'
