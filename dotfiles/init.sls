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
  cmd.run:
    - name: tar xf {{ dotfiles.cache_path }} --strip-components=1 -C {{ home }}
    - runas: {{ username }}
    - creates: {{ home }}/.zshrc
dotfiles_user_{{ username }}_reextract:
  cmd.run:
    - name: tar xf {{ dotfiles.cache_path }} --strip-components=1 -C {{ home }}
    - runas: {{ username }}
    - onchanges:
      - file: dotfiles_archive
{% endfor %}
