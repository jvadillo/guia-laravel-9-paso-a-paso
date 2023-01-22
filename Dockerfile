FROM squidfunk/mkdocs-material

RUN pip install --no-cache-dir \
  mkdocs-awesome-pages-plugin \
  mkdocs-minify-plugin \
  mkdocs-git-revision-date-localized-plugin \
  mkdocs-bibtex \
  mkdocs-img2fig-plugin \
  mkdocs-mermaid2-plugin

ENTRYPOINT ["mkdocs"]