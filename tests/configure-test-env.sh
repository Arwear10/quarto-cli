# Check R environment ---

echo ">>>> Configuring R environment"
r_exists=$(command -v Rscript)

if [ -z $r_exists ] 
then 
  echo "No Rscript found in PATH - Install R"
else
  Rscript -e 'renv::restore(repos = c(RSPM = "https://packagemanager.posit.co/cran/latest"))'
fi


# Check python test environment ---
echo ">>>> Configuring Python environment"
python_exists=$(command -v python)
if [ -z $python_exists ] 
then 
  echo "No python found in PATH - Install python."
else
  pipenv_exist=$(command -v pipenv)
  if [ -z $pipenv_exist ] 
  then
    python -m pip install pipenv
  fi
  # specific for pyenv shim
  [ -n $(command -v pyenv) ] && pyenv rehash
  echo "Setting up python environnement with pipenv"
  pipenv install
fi

# Check Julia environment ---
echo ">>>> Configuring Julia environment"
julia_exists=$(command -v julia)
if [ -z $julia_exists ] 
then 
  echo "No julia found in PATH - Install Julia."
else
  echo "Setting up Julia environment"
  julia --color=yes --project=. -e 'import Pkg; Pkg.instantiate(); Pkg.build("IJulia"); Pkg.precompile()'
fi

# Update tinytex
echo ">>>> Configuring TinyTeX environment"
if [ -z $GH_TOKEN ] && [ -n $(command -v gh) ]
then 
  echo "Setting GH_TOKEN env var for Github Download."
  export GH_TOKEN=$(gh auth token)
fi

if [ -n $(command -v quarto) ] 
then
  quarto install tinytex
fi