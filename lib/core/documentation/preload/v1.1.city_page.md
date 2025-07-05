## 📋 **Documentation - Système de Preload T0/T1**

### **🎯 Vue d'ensemble**

Le système de preload optimise l'expérience utilisateur lors du changement de ville en chargeant intelligemment les données en deux phases :

- **T0 (Critique ≤ 2.5s)** : Charge les données essentielles pour un affichage immédiat
- **T1 (Complétion ~1.5s)** : Complète automatiquement les données en arrière-plan

### **🔄 Flux utilisateur**

1. **User clique** sur CityPicker et sélectionne une ville
2. **Navigation** vers `/loading` avec paramètres (ville + type de page)
3. **LoadingRoute** démarre le PreloadController et précharge les images
4. **Navigation automatique** vers la page finale quand T0 terminé
5. **Complétion T1** : Les carrousels s'enrichissent automatiquement après 1.5s

### **⚙️ Logique T0/T1**

#### **Phase T0 - Chargement critique**
- **Carrousels 1-2** : 10 items chacun (événements + première catégorie)
- **Carrousels 3-7** : 5 items chacun (catégories suivantes)
- **Images** : Préchargement des thumbnails prioritaires
- **Navigation** : Dès que T0 terminé

#### **Phase T1 - Complétion automatique**
- **Timer 1.5s** : Déclenché automatiquement après affichage
- **Carrousels partiels** : Rechargés avec limite Supabase complète (≤30 items)
- **Update visuel** : Carrousels passent de 5 → 10+ items sans recharge de page

### **🔧 Architecture technique**

#### **Gestion des limites intelligente**
- **Preload** : Force les limites (5/10) via paramètre `p_limit`
- **Normal** : Utilise les limites de `merged_filter_config`
- **RPC Supabase** : Priorité au paramètre puis config base

#### **State Management**
- **PreloadController** : Orchestration et collecte des URLs d'images
- **CityExperiencesController** : Chargement granulaire avec limites custom
- **GenericExperienceCarousel** : Timer automatique et callback de complétion

---

### **📁 Fichiers concernés**

#### **🎮 Contrôleurs principaux**

**`features/preload/application/preload_controller.dart`**
- Orchestration T0 : chargement différentiel (2×10 + 5×5 items)
- Collecte des URLs d'images critiques pour préchargement
- Expose `CarouselLoadInfo` avec flags `isPartial`

**`features/preload/application/preload_providers.dart`**
- Provider Riverpod pour injection du PreloadController

**`features/city_page/application/providers/city_experiences_controller.dart`**
- Méthodes publiques pour preload avec limites custom
- Méthode `completeCarouselForCategory()` pour complétion T1
- Parsing robuste des limites depuis `merged_filter_config`

#### **🎨 Interface utilisateur**

**`features/preload/presentation/loading_route.dart`**
- Page de chargement avec spinner et texte dynamique
- Préchargement des images via `CachingImageProvider.precacheMultiple()`
- Navigation automatique quand preload terminé

**`features/shared_ui/widgets/molecules/city_picker.dart`**
- Déclenchement du preload au lieu de navigation directe
- Détection du type de page cible via `TargetPageService`

**`features/shared_ui/widgets/organisms/generic_experience_carousel.dart`**
- Conversion en StatefulWidget pour timer automatique
- Paramètres `isPartial` et `onRequestCompletion`
- Timer 1.5s qui déclenche la complétion T1

**`features/city_page/presentation/templates/city_page_template.dart`**
- Détection des carrousels partiels depuis preload data
- Callback `_completeCarousel()` qui appelle le controller
- Passage des flags aux carrousels

#### **🛠️ Services utilitaires**

**`features/preload/application/target_page_service.dart`**
- Détection du type de page cible (city/category) depuis la route

**`core/common/utils/caching_image_provider.dart`**
- Préchargement intelligent des images avec cache unifié
- Méthode `precacheMultiple()` avec contrôle de concurrence

#### **🏗️ Infrastructure backend**

**`core/adapters/supabase/search/activity_search_adapter.dart`**
- Transmission du paramètre `p_limit` aux fonctions RPC

**`core/adapters/supabase/search/event_search_adapter.dart`**
- Transmission du paramètre `p_limit` aux fonctions RPC

**Fonctions RPC Supabase : `get_activities_list` & `get_events_list`**
- Logique de limite : priorité `p_limit` puis `merged_filter_config`
- Support des limites dynamiques depuis l'application

#### **🔄 Navigation**

**`routes/app_router.dart`**
- Route `/loading` avec paramètres ville et type de page
- Passage des arguments au LoadingRoute

---

### **🧪 Points de validation**

#### **Performance T0**
- Chargement critique < 2.5s sur 4G
- Navigation immédiate possible après T0
- Préchargement de ~30-50 images thumbnails

#### **Expérience T1**
- Complétion automatique après 1.5s
- Transition fluide 5 → 10+ items par carrousel
- Pas de recharge complète de la page

#### **Robustesse**
- Gestion des erreurs de preload (navigation quand même)
- Annulation propre si changement de ville rapide
- Fallback vers limites par défaut si config manquante

---

### **🔮 Extensions prévues**

- **CategoryPage preload** : Même logique pour les pages catégories
- **Timeout management** : Fallback vers skeletons si délai dépassé
- **Cache optimisé** : Éviter rechargement si données déjà en cache
- **Monitoring** : Métriques de performance T0/T1 en production

---

**✅ Le système est opérationnel et testable à chaque étape.**