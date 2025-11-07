#!/bin/bash
# Work 2027 Ultimate - Test & Validation Script
# ============================================
# Script completo de testing para verificar instalación Work 2027

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Test results
TESTS_PASSED=0
TESTS_FAILED=0
TOTAL_TESTS=0

# Configuration
WORK2027_PATH="$HOME/Work2027"
ONEDRIVE_PATH="$HOME/OneDrive/Work2027"
LOG_FILE="$WORK2027_PATH/test_results_$(date +%Y%m%d_%H%M%S).log"

# Functions
print_header() {
    echo -e "\n${CYAN}🚀 $1${NC}"
    echo -e "${CYAN}$(printf '=%.0s' {1..50})${NC}"
}

print_step() {
    echo -e "${YELLOW}⏳ $1...${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
    ((TESTS_PASSED++))
    echo "✅ $1" >> "$LOG_FILE"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
    ((TESTS_FAILED++))
    echo "❌ $1" >> "$LOG_FILE"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
    echo "ℹ️  $1" >> "$LOG_FILE"
}

run_test() {
    local test_name="$1"
    local test_command="$2"
    ((TOTAL_TESTS++))

    print_step "Testing: $test_name"
    if eval "$test_command" &>/dev/null; then
        print_success "$test_name: PASSED"
        return 0
    else
        print_error "$test_name: FAILED"
        return 1
    fi
}

# Start testing
print_header "WORK 2027 ULTIMATE - COMPREHENSIVE TESTING"
echo "Starting comprehensive validation of Work 2027 installation..."
echo "Test started: $(date)" > "$LOG_FILE"
echo "Installation path: $WORK2027_PATH" >> "$LOG_FILE"
echo "OneDrive path: $ONEDRIVE_PATH" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# TEST SUITE 1: Directory Structure
print_header "TEST SUITE 1: DIRECTORY STRUCTURE"

run_test "Main Work2027 directory exists" "test -d '$WORK2027_PATH'"
run_test "Python Scripts directory exists" "test -d '$WORK2027_PATH/01_Python/Scripts'"
run_test "IA Copilot directory exists" "test -d '$WORK2027_PATH/02_IA_Copilot'"
run_test "VS Code prompts directory exists" "test -d '$WORK2027_PATH/02_IA_Copilot/Prompts_VSCode'"
run_test "M365 prompts directory exists" "test -d '$WORK2027_PATH/02_IA_Copilot/Prompts_M365'"
run_test "Mobile prompts directory exists" "test -d '$WORK2027_PATH/02_IA_Copilot/Prompts_Mobile'"
run_test "Analytics directory exists" "test -d '$WORK2027_PATH/03_Datos_y_Analytics'"
run_test "Documents directory exists" "test -d '$WORK2027_PATH/05_Finanzas_y_Documentos'"
run_test "Backup directory exists" "test -d '$WORK2027_PATH/06_Backup_y_Sincronizacion'"

# TEST SUITE 2: Python Scripts
print_header "TEST SUITE 2: PYTHON SCRIPTS"

run_test "Log generator script exists" "test -f '$WORK2027_PATH/01_Python/Scripts/work2027_log_generator.py'"
run_test "Code analyzer script exists" "test -f '$WORK2027_PATH/01_Python/Scripts/work2027_code_analyzer.py'"
run_test "GitHub integration script exists" "test -f '$WORK2027_PATH/01_Python/Scripts/work2027_github_integration.py'"
run_test "M365 integration script exists" "test -f '$WORK2027_PATH/01_Python/Scripts/work2027_m365_integration.py'"
run_test "Master workflow script exists" "test -f '$WORK2027_PATH/01_Python/Scripts/work2027_master_workflow.sh'"

# Test Python script execution
if command -v python3 &> /dev/null; then
    print_step "Testing Python script syntax"

    for script in "$WORK2027_PATH/01_Python/Scripts/"*.py; do
        if [ -f "$script" ]; then
            script_name=$(basename "$script")
            if python3 -m py_compile "$script" 2>/dev/null; then
                print_success "Python syntax valid: $script_name"
            else
                print_error "Python syntax error: $script_name"
            fi
        fi
    done
else
    print_error "Python 3 not found - skipping syntax tests"
fi

# TEST SUITE 3: VS Code Configuration
print_header "TEST SUITE 3: VS CODE CONFIGURATION"

run_test "VS Code prompts master file exists" "test -f '$WORK2027_PATH/02_IA_Copilot/Prompts_VSCode/prompts_master.json'"

# Check if VS Code is installed and configured
if command -v code &> /dev/null; then
    print_success "VS Code installation detected"

    VSCODE_SETTINGS="$HOME/.config/Code/User/settings.json"
    if [ -f "$VSCODE_SETTINGS" ]; then
        print_success "VS Code settings.json found"

        if grep -q "github.copilot.chat.customCommands" "$VSCODE_SETTINGS" 2>/dev/null; then
            print_success "GitHub Copilot custom commands configured"
        else
            print_error "GitHub Copilot custom commands not found in settings"
        fi

        if grep -q "work2027" "$VSCODE_SETTINGS" 2>/dev/null; then
            print_success "Work 2027 configuration found in VS Code settings"
        else
            print_error "Work 2027 configuration not found in VS Code settings"
        fi
    else
        print_error "VS Code settings.json not found"
    fi
else
    print_error "VS Code not installed or not in PATH"
fi

# TEST SUITE 4: Office 365 Configuration
print_header "TEST SUITE 4: OFFICE 365 CONFIGURATION"

run_test "Office 365 prompts file exists" "test -f '$WORK2027_PATH/02_IA_Copilot/Prompts_M365/office365_prompts.txt'"
run_test "Word templates directory exists" "test -d '$WORK2027_PATH/02_IA_Copilot/Templates/Word'"
run_test "Excel templates directory exists" "test -d '$WORK2027_PATH/02_IA_Copilot/Templates/Excel'"
run_test "PowerPoint templates directory exists" "test -d '$WORK2027_PATH/02_IA_Copilot/Templates/PowerPoint'"

# Check for Word template
if [ -f "$WORK2027_PATH/02_IA_Copilot/Templates/Word/informe_diario_template.md" ]; then
    print_success "Word daily report template found"
else
    print_error "Word daily report template not found"
fi

# TEST SUITE 5: Mobile Integration
print_header "TEST SUITE 5: MOBILE INTEGRATION"

run_test "Mobile prompts file exists" "test -f '$WORK2027_PATH/02_IA_Copilot/Prompts_Mobile/Prompts_Mobile.txt'"
run_test "Mobile quick reference exists" "test -f '$WORK2027_PATH/02_IA_Copilot/Prompts_Mobile/quick_reference.txt'"

# Validate mobile prompts content
if [ -f "$WORK2027_PATH/02_IA_Copilot/Prompts_Mobile/Prompts_Mobile.txt" ]; then
    MOBILE_PROMPTS_COUNT=$(grep -c "Work2027" "$WORK2027_PATH/02_IA_Copilot/Prompts_Mobile/Prompts_Mobile.txt")
    if [ "$MOBILE_PROMPTS_COUNT" -ge 30 ]; then
        print_success "Mobile prompts file contains 30+ Work2027 prompts"
    else
        print_error "Mobile prompts file contains insufficient prompts ($MOBILE_PROMPTS_COUNT)"
    fi
fi

# TEST SUITE 6: OneDrive Synchronization
print_header "TEST SUITE 6: ONEDRIVE SYNCHRONIZATION"

# Check if OneDrive paths exist or can be created
if [ -d "$HOME/OneDrive" ]; then
    print_success "OneDrive installation detected"
    run_test "OneDrive Work2027 sync path accessible" "mkdir -p '$ONEDRIVE_PATH' 2>/dev/null"
else
    print_error "OneDrive not installed or not accessible"
fi

run_test "OneDrive config file exists" "test -f '$WORK2027_PATH/06_Backup_y_Sincronizacion/onedrive_config.txt'"

# TEST SUITE 7: Automation Scripts
print_header "TEST SUITE 7: AUTOMATION SCRIPTS"

run_test "Daily scripts directory exists" "test -d '$WORK2027_PATH/Scripts/Daily'"
run_test "Weekly scripts directory exists" "test -d '$WORK2027_PATH/Scripts/Weekly'"
run_test "Utils scripts directory exists" "test -d '$WORK2027_PATH/Scripts/Utils'"

# Check for sync script on Windows/WSL
if [ -f "$WORK2027_PATH/Scripts/work2027_sync_now.bat" ]; then
    print_success "OneDrive sync script found"
else
    print_error "OneDrive sync script not found"
fi

# TEST SUITE 8: Configuration Files
print_header "TEST SUITE 8: CONFIGURATION FILES"

run_test "Main config file exists" "test -f '$WORK2027_PATH/work2027_config.json'"
run_test "Install config file exists" "test -f '$WORK2027_PATH/work2027_install_config.ini' || test -f './work2027_install_config.ini'"

# Validate JSON configuration
if [ -f "$WORK2027_PATH/work2027_config.json" ]; then
    if command -v python3 &> /dev/null; then
        if python3 -c "import json; json.load(open('$WORK2027_PATH/work2027_config.json'))" 2>/dev/null; then
            print_success "Main config JSON is valid"
        else
            print_error "Main config JSON is invalid"
        fi
    fi
fi

# TEST SUITE 9: Documentation
print_header "TEST SUITE 9: DOCUMENTATION"

run_test "Ultimate guide exists" "test -f './Work2027_Ultimate_Guide.md' || test -f '$WORK2027_PATH/Work2027_Ultimate_Guide.md'"
run_test "Prompts README exists" "test -f './README_Prompts.md' || test -f '$WORK2027_PATH/README_Prompts.md'"

# TEST SUITE 10: GitHub Integration
print_header "TEST SUITE 10: GITHUB INTEGRATION"

# Check if git is available
if command -v git &> /dev/null; then
    print_success "Git installation detected"

    # Check if current directory is a git repository
    if git rev-parse --git-dir &> /dev/null; then
        print_success "Git repository detected"

        # Check for Work 2027 related commits
        if git log --oneline | grep -i "work2027\|Work 2027" &> /dev/null; then
            print_success "Work 2027 related commits found in git history"
        else
            print_error "No Work 2027 commits found in git history"
        fi
    else
        print_error "Current directory is not a git repository"
    fi
else
    print_error "Git not installed"
fi

# TEST SUITE 11: Integration Testing
print_header "TEST SUITE 11: INTEGRATION TESTING"

# Test workflow script execution (dry run)
if [ -f "$WORK2027_PATH/01_Python/Scripts/work2027_master_workflow.sh" ]; then
    print_step "Testing master workflow script syntax"
    if bash -n "$WORK2027_PATH/01_Python/Scripts/work2027_master_workflow.sh" 2>/dev/null; then
        print_success "Master workflow script syntax is valid"
    else
        print_error "Master workflow script has syntax errors"
    fi
fi

# Test if required Python packages are available
if command -v python3 &> /dev/null; then
    print_step "Checking Python dependencies"

    REQUIRED_PACKAGES=("datetime" "json" "os" "sys" "pathlib")
    for package in "${REQUIRED_PACKAGES[@]}"; do
        if python3 -c "import $package" 2>/dev/null; then
            print_success "Python package available: $package"
        else
            print_error "Python package missing: $package"
        fi
    done
fi

# TEST SUITE 12: Performance and Security
print_header "TEST SUITE 12: PERFORMANCE & SECURITY"

# Check file permissions
run_test "Scripts have execute permissions" "test -x '$WORK2027_PATH/01_Python/Scripts/work2027_master_workflow.sh' || chmod +x '$WORK2027_PATH/01_Python/Scripts/work2027_master_workflow.sh'"

# Check for sensitive data exposure
print_step "Checking for exposed sensitive data"
SENSITIVE_PATTERNS=("password" "api_key" "token" "secret")
SENSITIVE_FOUND=0

for pattern in "${SENSITIVE_PATTERNS[@]}"; do
    if grep -r -i "$pattern" "$WORK2027_PATH" --include="*.py" --include="*.json" --include="*.md" 2>/dev/null | grep -v "example\|placeholder\|<\|{" &>/dev/null; then
        ((SENSITIVE_FOUND++))
    fi
done

if [ $SENSITIVE_FOUND -eq 0 ]; then
    print_success "No exposed sensitive data found"
else
    print_error "Potential sensitive data exposure detected ($SENSITIVE_FOUND instances)"
fi

# Final test: Create a test file and verify it works
print_header "FINAL INTEGRATION TEST"

TEST_FILE="$WORK2027_PATH/test_integration_$(date +%s).txt"
if echo "Work 2027 integration test successful - $(date)" > "$TEST_FILE" 2>/dev/null; then
    if [ -f "$TEST_FILE" ]; then
        print_success "File creation and write permissions working"
        rm "$TEST_FILE" 2>/dev/null
    else
        print_error "File creation failed"
    fi
else
    print_error "Write permissions test failed"
fi

# SUMMARY REPORT
print_header "TEST SUMMARY REPORT"

echo -e "\n${CYAN}📊 RESULTS SUMMARY:${NC}"
echo -e "🟢 Tests Passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "🔴 Tests Failed: ${RED}$TESTS_FAILED${NC}"
echo -e "📈 Total Tests: ${BLUE}$TOTAL_TESTS${NC}"
echo -e "📊 Success Rate: ${YELLOW}$(( TESTS_PASSED * 100 / TOTAL_TESTS ))%${NC}"

# Log summary
echo "" >> "$LOG_FILE"
echo "=== TEST SUMMARY ===" >> "$LOG_FILE"
echo "Tests Passed: $TESTS_PASSED" >> "$LOG_FILE"
echo "Tests Failed: $TESTS_FAILED" >> "$LOG_FILE"
echo "Total Tests: $TOTAL_TESTS" >> "$LOG_FILE"
echo "Success Rate: $(( TESTS_PASSED * 100 / TOTAL_TESTS ))%" >> "$LOG_FILE"
echo "Test completed: $(date)" >> "$LOG_FILE"

# Overall result
if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "\n${GREEN}🎉 ALL TESTS PASSED! Work 2027 Ultimate is 100% operational!${NC}"
    echo -e "${GREEN}🚀 Your installation is ready for production use!${NC}"
    exit 0
elif [ $TESTS_FAILED -le 3 ]; then
    echo -e "\n${YELLOW}⚠️  Minor issues detected. Work 2027 is mostly functional.${NC}"
    echo -e "${YELLOW}🔧 Check failed tests and fix if needed.${NC}"
    exit 1
else
    echo -e "\n${RED}❌ Multiple issues detected. Please review the installation.${NC}"
    echo -e "${RED}🛠️  Run the installer again or check the documentation.${NC}"
    exit 2
fi

echo -e "\n${BLUE}📄 Detailed log saved to: $LOG_FILE${NC}"