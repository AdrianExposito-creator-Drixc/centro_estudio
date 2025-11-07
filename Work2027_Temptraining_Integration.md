# 🎓 WORK 2027 TEMPTRAINING INTEGRATION

## 🎯 **AUTOMATIZACIÓN FORMACIÓN PROFESIONAL**

Integración completa entre Work 2027 y Temptraining para sincronizar:
- Cursos de Python, IA, Big Data, IoT, Cloud
- Certificaciones activas y próximas
- Roadmap personalizado de formación
- Actualización automática de Loop dashboard

---

## 🔧 **SCRIPT TEMPTRAINING CONNECTOR**

### 📊 **temptraining_connector.py**

```python
#!/usr/bin/env python3
"""
Work 2027 Temptraining Integration
=================================

Conecta con Temptraining para extraer cursos, certificaciones y progreso.
Actualiza automáticamente el roadmap Work 2027 con enlaces reales.
"""

import requests
import json
import re
from bs4 import BeautifulSoup
import datetime
from typing import Dict, List, Optional
from dataclasses import dataclass
import logging
from urllib.parse import urljoin, urlparse
import time
import os

# Configuración logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

@dataclass
class Course:
    """Estructura de datos para cursos."""
    title: str
    url: str
    category: str
    duration: str
    level: str
    status: str  # available, enrolled, completed
    certification: bool
    technology: str  # Python, IA, BigData, IoT, Cloud
    description: str
    start_date: Optional[str] = None
    completion_date: Optional[str] = None

@dataclass
class Certification:
    """Estructura de datos para certificaciones."""
    name: str
    url: str
    provider: str
    status: str  # active, expired, in_progress
    issue_date: Optional[str] = None
    expiry_date: Optional[str] = None
    credential_id: Optional[str] = None

class TemptrainingConnector:
    """Conector para extraer datos de Temptraining."""

    def __init__(self, config_file: str = "temptraining_config.json"):
        """Inicializar conector con configuración."""
        self.config = self._load_config(config_file)
        self.session = requests.Session()
        self.base_url = "https://temptraining.es"
        self.authenticated = False

        # Headers para simular navegador real
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
            'Accept-Language': 'es-ES,es;q=0.5',
            'Accept-Encoding': 'gzip, deflate',
            'Connection': 'keep-alive',
        })

    def _load_config(self, config_file: str) -> Dict:
        """Cargar configuración de acceso."""
        try:
            with open(config_file, 'r', encoding='utf-8') as f:
                return json.load(f)
        except FileNotFoundError:
            logger.warning(f"Config file {config_file} not found. Creating default.")
            return self._create_default_config(config_file)

    def _create_default_config(self, config_file: str) -> Dict:
        """Crear configuración por defecto."""
        default_config = {
            "temptraining_email": os.getenv("TEMPTRAINING_EMAIL", ""),
            "temptraining_password": os.getenv("TEMPTRAINING_PASSWORD", ""),
            "target_technologies": ["Python", "IA", "Inteligencia Artificial", "Big Data", "IoT", "Cloud", "AWS", "Azure"],
            "preferred_levels": ["Básico", "Intermedio", "Avanzado"],
            "max_courses_per_tech": 5,
            "enable_auto_enrollment": False,
            "update_frequency_hours": 24,
            "export_formats": ["json", "pdf", "loop"]
        }

        with open(config_file, 'w', encoding='utf-8') as f:
            json.dump(default_config, f, indent=2, ensure_ascii=False)

        logger.info(f"Created default config: {config_file}")
        return default_config

    def authenticate(self) -> bool:
        """Autenticar con Temptraining."""
        logger.info("🔐 Autenticando con Temptraining...")

        try:
            # Obtener página de login
            login_url = f"{self.base_url}/login"
            response = self.session.get(login_url)
            response.raise_for_status()

            soup = BeautifulSoup(response.content, 'html.parser')

            # Buscar token CSRF si existe
            csrf_token = None
            csrf_input = soup.find('input', {'name': '_token'})
            if csrf_input:
                csrf_token = csrf_input.get('value')

            # Datos de login
            login_data = {
                'email': self.config['temptraining_email'],
                'password': self.config['temptraining_password']
            }

            if csrf_token:
                login_data['_token'] = csrf_token

            # Realizar login
            login_response = self.session.post(login_url, data=login_data)

            # Verificar si el login fue exitoso
            if "dashboard" in login_response.url.lower() or "perfil" in login_response.url.lower():
                self.authenticated = True
                logger.info("✅ Autenticación exitosa")
                return True
            else:
                logger.error("❌ Error en autenticación")
                return False

        except Exception as e:
            logger.error(f"❌ Error autenticando: {e}")
            return False

    def get_available_courses(self) -> List[Course]:
        """Obtener cursos disponibles filtrados por tecnologías objetivo."""
        logger.info("📚 Obteniendo cursos disponibles...")

        courses = []
        target_techs = self.config['target_technologies']

        try:
            # Páginas a explorar
            course_pages = [
                "/cursos",
                "/formacion",
                "/python",
                "/inteligencia-artificial",
                "/big-data",
                "/iot",
                "/cloud"
            ]

            for page in course_pages:
                try:
                    url = urljoin(self.base_url, page)
                    response = self.session.get(url)

                    if response.status_code == 200:
                        courses.extend(self._parse_course_page(response.content, url))

                    time.sleep(1)  # Rate limiting

                except Exception as e:
                    logger.warning(f"Error en página {page}: {e}")
                    continue

            # Filtrar por tecnologías objetivo
            filtered_courses = []
            for course in courses:
                for tech in target_techs:
                    if tech.lower() in course.title.lower() or tech.lower() in course.description.lower():
                        course.technology = tech
                        filtered_courses.append(course)
                        break

            logger.info(f"✅ Encontrados {len(filtered_courses)} cursos relevantes")
            return filtered_courses

        except Exception as e:
            logger.error(f"❌ Error obteniendo cursos: {e}")
            return []

    def _parse_course_page(self, html_content: bytes, page_url: str) -> List[Course]:
        """Parsear página de cursos y extraer información."""
        courses = []

        try:
            soup = BeautifulSoup(html_content, 'html.parser')

            # Buscar diferentes patrones de cursos
            course_selectors = [
                '.course-item',
                '.curso',
                '.training-item',
                'article.course',
                '.card-course'
            ]

            course_elements = []
            for selector in course_selectors:
                elements = soup.select(selector)
                if elements:
                    course_elements = elements
                    break

            # Si no encuentra con selectores específicos, buscar enlaces con palabras clave
            if not course_elements:
                course_elements = soup.find_all('a', href=True)

            for element in course_elements:
                try:
                    course = self._extract_course_info(element, page_url)
                    if course:
                        courses.append(course)
                except Exception as e:
                    continue

        except Exception as e:
            logger.warning(f"Error parseando página: {e}")

        return courses

    def _extract_course_info(self, element, base_url: str) -> Optional[Course]:
        """Extraer información de un curso desde un elemento HTML."""
        try:
            # Título del curso
            title = ""
            title_selectors = ['h3', 'h4', '.title', '.course-title', 'a']
            for selector in title_selectors:
                title_elem = element.select_one(selector)
                if title_elem:
                    title = title_elem.get_text(strip=True)
                    break

            if not title:
                return None

            # URL del curso
            url = ""
            if element.name == 'a':
                url = element.get('href', '')
            else:
                link = element.find('a', href=True)
                if link:
                    url = link['href']

            if url:
                url = urljoin(base_url, url)

            # Descripción
            description = ""
            desc_selectors = ['.description', '.excerpt', 'p', '.summary']
            for selector in desc_selectors:
                desc_elem = element.select_one(selector)
                if desc_elem:
                    description = desc_elem.get_text(strip=True)[:200]
                    break

            # Duración y nivel (estimados)
            duration = self._extract_duration(element) or "Variable"
            level = self._extract_level(element) or "Intermedio"

            # Verificar si es relevante para Work 2027
            target_keywords = ["python", "ia", "inteligencia", "artificial", "big", "data", "iot", "cloud", "aws", "azure"]
            text_to_check = f"{title} {description}".lower()

            is_relevant = any(keyword in text_to_check for keyword in target_keywords)

            if is_relevant:
                return Course(
                    title=title,
                    url=url,
                    category="Formación Técnica",
                    duration=duration,
                    level=level,
                    status="available",
                    certification=True,  # Asumimos que Temptraining da certificaciones
                    technology="",  # Se asignará después
                    description=description
                )

        except Exception as e:
            logger.debug(f"Error extrayendo curso: {e}")

        return None

    def _extract_duration(self, element) -> Optional[str]:
        """Extraer duración del curso."""
        text = element.get_text()

        # Buscar patrones de duración
        duration_patterns = [
            r'(\d+)\s*horas?',
            r'(\d+)\s*h',
            r'(\d+)\s*días?',
            r'(\d+)\s*semanas?',
            r'(\d+)\s*meses?'
        ]

        for pattern in duration_patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                return match.group(0)

        return None

    def _extract_level(self, element) -> Optional[str]:
        """Extraer nivel del curso."""
        text = element.get_text().lower()

        if any(word in text for word in ['básico', 'principiante', 'inicial']):
            return "Básico"
        elif any(word in text for word in ['intermedio', 'medio']):
            return "Intermedio"
        elif any(word in text for word in ['avanzado', 'experto', 'profesional']):
            return "Avanzado"

        return None

    def get_my_certifications(self) -> List[Certification]:
        """Obtener certificaciones del usuario."""
        logger.info("🏆 Obteniendo certificaciones...")

        if not self.authenticated:
            logger.warning("❌ No autenticado. Intentando autenticar...")
            if not self.authenticate():
                return []

        certifications = []

        try:
            # Buscar en páginas de perfil/dashboard
            profile_pages = [
                "/perfil",
                "/dashboard",
                "/mis-cursos",
                "/certificaciones",
                "/mi-cuenta"
            ]

            for page in profile_pages:
                try:
                    url = urljoin(self.base_url, page)
                    response = self.session.get(url)

                    if response.status_code == 200:
                        certs = self._parse_certifications_page(response.content)
                        certifications.extend(certs)

                    time.sleep(1)

                except Exception as e:
                    continue

            logger.info(f"✅ Encontradas {len(certifications)} certificaciones")
            return certifications

        except Exception as e:
            logger.error(f"❌ Error obteniendo certificaciones: {e}")
            return []

    def _parse_certifications_page(self, html_content: bytes) -> List[Certification]:
        """Parsear página de certificaciones."""
        certifications = []

        try:
            soup = BeautifulSoup(html_content, 'html.parser')

            # Buscar elementos de certificaciones
            cert_selectors = [
                '.certification',
                '.certificate',
                '.badge',
                '.achievement',
                '.completed-course'
            ]

            cert_elements = []
            for selector in cert_selectors:
                elements = soup.select(selector)
                if elements:
                    cert_elements.extend(elements)

            for element in cert_elements:
                try:
                    cert = self._extract_certification_info(element)
                    if cert:
                        certifications.append(cert)
                except Exception as e:
                    continue

        except Exception as e:
            logger.warning(f"Error parseando certificaciones: {e}")

        return certifications

    def _extract_certification_info(self, element) -> Optional[Certification]:
        """Extraer información de certificación."""
        try:
            # Nombre de la certificación
            name_selectors = ['h3', 'h4', '.cert-name', '.title']
            name = ""
            for selector in name_selectors:
                name_elem = element.select_one(selector)
                if name_elem:
                    name = name_elem.get_text(strip=True)
                    break

            if not name:
                return None

            # URL del certificado
            url = ""
            link = element.find('a', href=True)
            if link:
                url = link['href']

            # Estado (activa, expirada, en progreso)
            status = "active"
            status_text = element.get_text().lower()
            if "expirado" in status_text or "vencido" in status_text:
                status = "expired"
            elif "progreso" in status_text or "cursando" in status_text:
                status = "in_progress"

            return Certification(
                name=name,
                url=url,
                provider="Temptraining",
                status=status
            )

        except Exception as e:
            logger.debug(f"Error extrayendo certificación: {e}")

        return None

    def generate_work2027_roadmap(self, courses: List[Course], certifications: List[Certification]) -> Dict:
        """Generar roadmap Work 2027 personalizado."""
        logger.info("🗺️ Generando roadmap Work 2027...")

        # Organizar por tecnología
        tech_roadmap = {
            "Python": [],
            "IA": [],
            "Big Data": [],
            "IoT": [],
            "Cloud": []
        }

        # Clasificar cursos por tecnología
        for course in courses:
            tech = course.technology
            if "Python" in tech:
                tech_roadmap["Python"].append(course)
            elif any(keyword in tech.lower() for keyword in ["ia", "inteligencia", "artificial"]):
                tech_roadmap["IA"].append(course)
            elif any(keyword in tech.lower() for keyword in ["big", "data"]):
                tech_roadmap["Big Data"].append(course)
            elif "iot" in tech.lower():
                tech_roadmap["IoT"].append(course)
            elif any(keyword in tech.lower() for keyword in ["cloud", "aws", "azure"]):
                tech_roadmap["Cloud"].append(course)

        # Crear roadmap estructurado
        roadmap = {
            "generated_date": datetime.datetime.now().isoformat(),
            "total_courses": len(courses),
            "total_certifications": len(certifications),
            "technologies": tech_roadmap,
            "certifications": certifications,
            "recommendations": self._generate_recommendations(tech_roadmap, certifications),
            "work2027_integration": {
                "github_integration": True,
                "copilot_prompts": self._generate_copilot_prompts(tech_roadmap),
                "productivity_impact": self._calculate_productivity_impact(courses)
            }
        }

        return roadmap

    def _generate_recommendations(self, tech_roadmap: Dict, certifications: List[Certification]) -> List[str]:
        """Generar recomendaciones personalizadas."""
        recommendations = []

        # Analizar gaps en el roadmap
        for tech, courses in tech_roadmap.items():
            if len(courses) == 0:
                recommendations.append(f"🎯 Considera añadir cursos de {tech} para completar tu perfil Work 2027")
            elif len(courses) < 2:
                recommendations.append(f"📈 Amplía conocimientos en {tech} con cursos avanzados")

        # Recomendaciones basadas en certificaciones
        if len(certifications) < 3:
            recommendations.append("🏆 Objetivo: Obtener al menos 3 certificaciones técnicas")

        # Recomendaciones específicas Work 2027
        recommendations.extend([
            "🤖 Prioriza cursos de IA para maximizar uso de GitHub Copilot",
            "☁️ Certificaciones Cloud complementan automatización Work 2027",
            "📊 Big Data skills potencian métricas y analytics del ecosistema"
        ])

        return recommendations

    def _generate_copilot_prompts(self, tech_roadmap: Dict) -> List[str]:
        """Generar prompts para GitHub Copilot basados en el roadmap."""
        prompts = []

        for tech, courses in tech_roadmap.items():
            if courses:
                prompts.append(f"@copilot Generar plan de estudio {tech} basado en cursos Temptraining")
                prompts.append(f"@copilot Crear proyecto práctico {tech} para aplicar conocimientos")

        return prompts

    def _calculate_productivity_impact(self, courses: List[Course]) -> Dict:
        """Calcular impacto en productividad Work 2027."""
        return {
            "skill_multiplier": min(3.0, 1 + (len(courses) * 0.1)),
            "automation_potential": len(courses) * 15,  # % adicional de automatización
            "estimated_time_savings": len(courses) * 30,  # minutos por día
            "career_advancement_score": min(100, len(courses) * 8)
        }

    def export_to_loop_format(self, roadmap: Dict) -> str:
        """Exportar roadmap en formato compatible con Microsoft Loop."""
        logger.info("📋 Exportando a formato Loop...")

        loop_content = """
# 🎓 Work 2027 Learning Roadmap - Temptraining Integration

## 📊 Resumen Ejecutivo
- **Total Cursos Identificados**: {total_courses}
- **Certificaciones Activas**: {total_certifications}
- **Fecha Actualización**: {date}

## 🚀 Roadmap por Tecnología

### 🐍 Python
{python_courses}

### 🤖 Inteligencia Artificial
{ia_courses}

### 📊 Big Data
{bigdata_courses}

### 🌐 IoT
{iot_courses}

### ☁️ Cloud Computing
{cloud_courses}

## 🏆 Certificaciones
{certifications}

## 🎯 Recomendaciones Work 2027
{recommendations}

## 🤖 Integración Copilot
{copilot_prompts}

---
*Actualizado automáticamente por Work 2027 Temptraining Connector*
        """.format(
            total_courses=roadmap['total_courses'],
            total_certifications=roadmap['total_certifications'],
            date=roadmap['generated_date'][:10],
            python_courses=self._format_courses_for_loop(roadmap['technologies']['Python']),
            ia_courses=self._format_courses_for_loop(roadmap['technologies']['IA']),
            bigdata_courses=self._format_courses_for_loop(roadmap['technologies']['Big Data']),
            iot_courses=self._format_courses_for_loop(roadmap['technologies']['IoT']),
            cloud_courses=self._format_courses_for_loop(roadmap['technologies']['Cloud']),
            certifications=self._format_certifications_for_loop(roadmap['certifications']),
            recommendations='\n'.join([f"- {rec}" for rec in roadmap['recommendations']]),
            copilot_prompts='\n'.join([f"- `{prompt}`" for prompt in roadmap['work2027_integration']['copilot_prompts']])
        )

        return loop_content

    def _format_courses_for_loop(self, courses: List[Course]) -> str:
        """Formatear cursos para Loop."""
        if not courses:
            return "- *No hay cursos disponibles en esta categoría*"

        formatted = []
        for course in courses[:5]:  # Máximo 5 cursos por tecnología
            status_emoji = "✅" if course.status == "completed" else "📚" if course.status == "enrolled" else "🔗"
            formatted.append(f"- {status_emoji} [{course.title}]({course.url}) - {course.level} ({course.duration})")

        return '\n'.join(formatted)

    def _format_certifications_for_loop(self, certifications: List[Certification]) -> str:
        """Formatear certificaciones para Loop."""
        if not certifications:
            return "- *No hay certificaciones registradas*"

        formatted = []
        for cert in certifications:
            status_emoji = "🏆" if cert.status == "active" else "⏳" if cert.status == "in_progress" else "❌"
            formatted.append(f"- {status_emoji} [{cert.name}]({cert.url}) - {cert.provider}")

        return '\n'.join(formatted)

    def save_roadmap(self, roadmap: Dict, formats: List[str] = None) -> Dict[str, str]:
        """Guardar roadmap en múltiples formatos."""
        if formats is None:
            formats = self.config.get('export_formats', ['json'])

        saved_files = {}
        timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")

        try:
            # JSON
            if 'json' in formats:
                json_file = f"work2027_temptraining_roadmap_{timestamp}.json"
                with open(json_file, 'w', encoding='utf-8') as f:
                    json.dump(roadmap, f, indent=2, ensure_ascii=False, default=str)
                saved_files['json'] = json_file

            # Loop format
            if 'loop' in formats:
                loop_content = self.export_to_loop_format(roadmap)
                loop_file = f"work2027_temptraining_roadmap_{timestamp}.loop.md"
                with open(loop_file, 'w', encoding='utf-8') as f:
                    f.write(loop_content)
                saved_files['loop'] = loop_file

            # Markdown
            if 'md' in formats:
                md_content = self.export_to_loop_format(roadmap)  # Mismo formato
                md_file = f"work2027_temptraining_roadmap_{timestamp}.md"
                with open(md_file, 'w', encoding='utf-8') as f:
                    f.write(md_content)
                saved_files['markdown'] = md_file

            logger.info(f"✅ Roadmap guardado en {len(saved_files)} formatos")

        except Exception as e:
            logger.error(f"❌ Error guardando roadmap: {e}")

        return saved_files

async def main():
    """Función principal para ejecutar la integración completa."""
    print("🚀 WORK 2027 TEMPTRAINING INTEGRATION")
    print("=" * 50)

    # Inicializar connector
    connector = TemptrainingConnector()

    try:
        # 1. Autenticar (opcional si hay credenciales)
        print("🔐 Intentando autenticación...")
        auth_success = connector.authenticate()

        # 2. Obtener cursos disponibles
        print("📚 Obteniendo cursos disponibles...")
        courses = connector.get_available_courses()

        # 3. Obtener certificaciones (requiere autenticación)
        print("🏆 Obteniendo certificaciones...")
        certifications = []
        if auth_success:
            certifications = connector.get_my_certifications()
        else:
            print("⚠️ Sin autenticación - saltando certificaciones personales")

        # 4. Generar roadmap
        print("🗺️ Generando roadmap Work 2027...")
        roadmap = connector.generate_work2027_roadmap(courses, certifications)

        # 5. Guardar en múltiples formatos
        print("💾 Guardando roadmap...")
        saved_files = connector.save_roadmap(roadmap, ['json', 'loop', 'md'])

        # 6. Mostrar resumen
        print("\n✅ INTEGRACIÓN COMPLETADA")
        print("=" * 30)
        print(f"📚 Cursos encontrados: {len(courses)}")
        print(f"🏆 Certificaciones: {len(certifications)}")
        print(f"📁 Archivos generados: {len(saved_files)}")

        for format_type, file_path in saved_files.items():
            print(f"   {format_type.upper()}: {file_path}")

        # 7. Mostrar recomendaciones clave
        if roadmap.get('recommendations'):
            print("\n🎯 RECOMENDACIONES PRINCIPALES:")
            for rec in roadmap['recommendations'][:3]:
                print(f"   {rec}")

        return roadmap

    except Exception as e:
        print(f"❌ Error en integración: {e}")
        return None

if __name__ == "__main__":
    import asyncio
    asyncio.run(main())
```

---

## ⚙️ **ARCHIVO DE CONFIGURACIÓN**

### 📝 **temptraining_config.json**

```json
{
  "temptraining_email": "",
  "temptraining_password": "",
  "target_technologies": [
    "Python",
    "IA",
    "Inteligencia Artificial",
    "Machine Learning",
    "Big Data",
    "Data Science",
    "IoT",
    "Internet of Things",
    "Cloud",
    "AWS",
    "Azure",
    "DevOps",
    "Automation"
  ],
  "preferred_levels": ["Básico", "Intermedio", "Avanzado"],
  "max_courses_per_tech": 5,
  "enable_auto_enrollment": false,
  "update_frequency_hours": 24,
  "export_formats": ["json", "loop", "md", "pdf"],
  "filters": {
    "min_duration_hours": 1,
    "max_duration_hours": 100,
    "certification_required": true,
    "free_courses_only": false
  },
  "work2027_integration": {
    "sync_with_github": true,
    "update_copilot_prompts": true,
    "generate_practice_projects": true,
    "track_productivity_impact": true
  }
}
```

---

## 🔄 **GITHUB ACTION PARA AUTOMATIZACIÓN**

### 📋 **temptraining-sync.yml**

```yaml
name: 🎓 Temptraining Learning Sync

on:
  schedule:
    - cron: '0 9 * * 1'  # Every Monday at 9 AM
  workflow_dispatch:
    inputs:
      force_sync:
        description: 'Force full synchronization'
        required: false
        default: 'false'
        type: boolean

jobs:
  sync-temptraining:
    name: 🔄 Sync Temptraining Data
    runs-on: ubuntu-latest

    steps:
    - name: 📥 Checkout
      uses: actions/checkout@v4

    - name: 🐍 Setup Python
      uses: actions/setup-python@v4
      with:
        python-version: '3.11'

    - name: 📦 Install Dependencies
      run: |
        pip install requests beautifulsoup4 lxml

    - name: 🎓 Run Temptraining Sync
      env:
        TEMPTRAINING_EMAIL: ${{ secrets.TEMPTRAINING_EMAIL }}
        TEMPTRAINING_PASSWORD: ${{ secrets.TEMPTRAINING_PASSWORD }}
      run: |
        python temptraining_connector.py

    - name: 📊 Process Results
      run: |
        echo "🎓 Temptraining Sync Results:"
        if [ -f work2027_temptraining_roadmap_*.json ]; then
          echo "✅ Roadmap JSON generated"
          ls -la work2027_temptraining_roadmap_*.json
        fi

        if [ -f work2027_temptraining_roadmap_*.loop.md ]; then
          echo "✅ Loop format generated"
          ls -la work2027_temptraining_roadmap_*.loop.md
        fi

    - name: 📤 Upload Learning Artifacts
      uses: actions/upload-artifact@v3
      with:
        name: temptraining-roadmap-${{ github.run_number }}
        path: |
          work2027_temptraining_roadmap_*.json
          work2027_temptraining_roadmap_*.loop.md
          work2027_temptraining_roadmap_*.md
        retention-days: 90

    - name: 🔄 Update Work2027 Dashboard
      run: |
        # Update main roadmap file
        if [ -f work2027_temptraining_roadmap_*.loop.md ]; then
          cp work2027_temptraining_roadmap_*.loop.md Work2027_Learning_Roadmap.md
          git config --local user.email "action@github.com"
          git config --local user.name "GitHub Action"
          git add Work2027_Learning_Roadmap.md
          git commit -m "🎓 Auto-update: Temptraining Learning Roadmap" || echo "No changes to commit"
          git push || echo "Nothing to push"
        fi
```

---

## 📋 **SCRIPT DE INSTALACIÓN Y CONFIGURACIÓN**

### 🛠️ **setup_temptraining_integration.py**

```python
#!/usr/bin/env python3
"""
Setup script para Work 2027 Temptraining Integration
"""

import os
import json
import subprocess
import sys

def install_dependencies():
    """Instalar dependencias necesarias."""
    print("📦 Instalando dependencias...")

    dependencies = [
        "requests",
        "beautifulsoup4",
        "lxml",
        "reportlab"  # Para PDF generation
    ]

    for dep in dependencies:
        try:
            subprocess.check_call([sys.executable, "-m", "pip", "install", dep])
            print(f"✅ {dep} instalado")
        except subprocess.CalledProcessError:
            print(f"❌ Error instalando {dep}")

def setup_config():
    """Configurar archivo de configuración."""
    print("⚙️ Configurando Temptraining integration...")

    email = input("📧 Email Temptraining (opcional): ").strip()
    password = input("🔐 Password Temptraining (opcional): ").strip()

    config = {
        "temptraining_email": email,
        "temptraining_password": password,
        "target_technologies": [
            "Python", "IA", "Big Data", "IoT", "Cloud", "AWS", "Azure"
        ],
        "preferred_levels": ["Básico", "Intermedio", "Avanzado"],
        "max_courses_per_tech": 5,
        "enable_auto_enrollment": False,
        "update_frequency_hours": 24,
        "export_formats": ["json", "loop", "md"]
    }

    with open("temptraining_config.json", "w", encoding="utf-8") as f:
        json.dump(config, f, indent=2, ensure_ascii=False)

    print("✅ Configuración guardada en temptraining_config.json")

def create_github_secrets_guide():
    """Crear guía para configurar GitHub Secrets."""
    guide = """
# 🔐 GitHub Secrets Configuration

Para automatizar la sincronización, configura estos secrets en tu repositorio:

## En GitHub > Settings > Secrets and variables > Actions:

1. **TEMPTRAINING_EMAIL**
   - Valor: tu-email@dominio.com

2. **TEMPTRAINING_PASSWORD**
   - Valor: tu-password-temptraining

## Comandos para configurar localmente:

```bash
# Exportar variables de entorno (Linux/macOS)
export TEMPTRAINING_EMAIL="tu-email@dominio.com"
export TEMPTRAINING_PASSWORD="tu-password"

# PowerShell (Windows)
$env:TEMPTRAINING_EMAIL="tu-email@dominio.com"
$env:TEMPTRAINING_PASSWORD="tu-password"
```

## Testing:

```bash
# Ejecutar sync manual
python temptraining_connector.py

# Verificar archivos generados
ls -la work2027_temptraining_roadmap_*
```
    """

    with open("TEMPTRAINING_SETUP_GUIDE.md", "w", encoding="utf-8") as f:
        f.write(guide)

    print("📚 Guía creada: TEMPTRAINING_SETUP_GUIDE.md")

def main():
    """Función principal de setup."""
    print("🚀 WORK 2027 TEMPTRAINING INTEGRATION SETUP")
    print("=" * 50)

    # 1. Instalar dependencias
    install_dependencies()

    # 2. Configurar credenciales
    setup_config()

    # 3. Crear guía de GitHub Secrets
    create_github_secrets_guide()

    # 4. Test básico
    print("\n🧪 Ejecutando test básico...")
    try:
        subprocess.check_call([sys.executable, "temptraining_connector.py"])
        print("✅ Test exitoso!")
    except subprocess.CalledProcessError:
        print("⚠️ Test con errores - revisar configuración")

    print("\n🎯 SETUP COMPLETADO!")
    print("=" * 20)
    print("📁 Archivos creados:")
    print("   - temptraining_config.json")
    print("   - TEMPTRAINING_SETUP_GUIDE.md")
    print("\n🔄 Próximos pasos:")
    print("   1. Configurar credenciales en temptraining_config.json")
    print("   2. Ejecutar: python temptraining_connector.py")
    print("   3. Configurar GitHub Secrets para automatización")

if __name__ == "__main__":
    main()
```

---

**🎓 Work 2027 Temptraining Integration Completada**
**🔄 Sincronización automática | 📚 Roadmap personalizado | 🎯 Integración Loop**

---

*Generated by Work 2027 Learning Automation System*
*Compatible with Temptraining, Microsoft Loop, GitHub Actions*