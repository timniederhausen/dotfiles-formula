{% from 'dotfiles/map.jinja' import dotfiles with context %}

# So far this is called the same everywhere
keychain:
  pkg.installed

dotfiles_archive:
  file.managed:
    - name: {{ dotfiles.cache_path }}
    - source: {{ dotfiles.url }}
    - skip_verify: true

{% for username in dotfiles.users %}
{% set home = '/root' if username == 'root' else '/home/' + username %}
dotfiles_user_{{ username }}:
  archive.extracted:
    - name: {{ home }}
    - source: file://{{ dotfiles.cache_path }}
    - archive_format: tar
    - tar_options: --strip-components=1
    - user: {{ username }}
    - if_missing: {{ home }}/.zshrc
    - enforce_toplevel: false
{% endfor %}
