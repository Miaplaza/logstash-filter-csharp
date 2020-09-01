import sys

try:
  input("Are you sure you are on the master branch which is identical to origin/master and there are no pending changes? [ENTER]")
except KeyboardInterrupt:
  sys.exit(1)

from rever.activity import Activity

class Gem(Activity):
    def __init__(self, **kwargs):
        super().__init__()
        self.name = "gem"
        self.desc = "Create a ruby gem"
        self.requires = {"commands": {"gem": "gem"}}

    def __call__(self):
        gem build logstash-filter-csharp.gemspec
        return True


class RubyGems(Activity):
    def __init__(self, **kwargs):
        super().__init__()
        self.name = "rubygems"
        self.desc = "Upload a ruby gem"
        self.requires = {"commands": {"gem": "gem"}}

    def __call__(self):
        gem push logstash-filter-csharp-$VERSION.gem
        return True


$DAG['gem'] = Gem()
$DAG['rubygems'] = RubyGems()


$PROJECT = 'logstash-filter-csharp'

$ACTIVITIES = [
    'version_bump',
    'changelog',
    'gem',
    'rubygems',
    'tag',
    'push_tag',
    'ghrelease',
]

$VERSION_BUMP_PATTERNS = [
    ('logstash-filter-csharp.gemspec', r's.version = ', r"s.version = '$VERSION'"),
]

$CHANGELOG_FILENAME = 'CHANGELOG.md'
$CHANGELOG_TEMPLATE = 'TEMPLATE.rst'
$PUSH_TAG_REMOTE = 'git@github.com:miaplaza/logstash-filter-csharp.git'

$GITHUB_ORG = 'miaplaza'
$GITHUB_REPO = 'logstash-filter-csharp'
