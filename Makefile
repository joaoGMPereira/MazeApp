generate: ## Generate project, workspace and install pods
	
	@$(MAKE) generateprojects
	@$(MAKE) installpods

generateprojects:
	@. ./Scripts/generateProject.sh;

installpods:
	@echo "\nInstalling Pods"
	pod install || pod install --repo-update
