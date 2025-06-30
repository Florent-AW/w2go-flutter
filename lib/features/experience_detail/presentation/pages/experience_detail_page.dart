// lib/features/experience_detail/presentation/pages/experience_detail_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/domain/models/shared/experience_item.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../organisms/experience_header_carousel.dart';
import '../organisms/experience_intro_section.dart';
import '../organisms/experience_info_section.dart';
import '../organisms/experience_description_panel.dart';
import '../organisms/activity_recommendations_section.dart';
import '../organisms/experience_floating_action_bar.dart';
import '../organisms/experience_top_bar.dart';
import '../../application/providers/experience_detail_providers.dart';

/// ✅ VERSION SIMPLE : Page de détail qui marche avec Hero classique
class ExperienceDetailPage extends ConsumerStatefulWidget {
  final ExperienceItem experienceItem;
  final VoidCallback onClose;
  final String? heroTag;

  const ExperienceDetailPage({
    Key? key,
    required this.experienceItem,
    required this.onClose,
    this.heroTag,
  }) : super(key: key);

  @override
  ConsumerState<ExperienceDetailPage> createState() => _ExperienceDetailPageState();
}

class _ExperienceDetailPageState extends ConsumerState<ExperienceDetailPage> {
  bool _showBody = false;
  bool _showCarousel = false;
  late ScrollController _scrollController;
  bool _showTopBar = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _loadExperienceDetails();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _listenToHeroAnimation();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _cleanupHeroListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final detailState = ref.watch(experienceDetailProvider(widget.experienceItem));
    final heroTag = widget.heroTag ?? 'experience-hero-${widget.experienceItem.id}';

    final imageUrls = detailState.maybeWhen(
      loaded: (details) => details.imageUrls,
      orElse: () => [widget.experienceItem.mainImageUrl ?? ''],
    );

    print('📄 PROGRESSIVE PAGE: showBody=$_showBody, showCarousel=$_showCarousel, images=${imageUrls.length}');

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // ✅ PROGRESSIVE : CustomScrollView avec contrôle progressif
          CustomScrollView(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            slivers: [
              // ✅ PROGRESSIVE : Header avec contrôle carousel
              SliverToBoxAdapter(
                child: ExperienceHeaderCarousel(
                  imageUrls: imageUrls,
                  heroTag: heroTag,
                  experienceId: widget.experienceItem.id,
                  onDismiss: widget.onClose,
                  showCarousel: _showCarousel, // ✅ CONTRÔLE PROGRESSIF
                ),
              ),

              // ✅ DONNÉES IMMÉDIATES : Toujours visibles (même pendant transition Hero)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(AppDimensions.spacingM),
                  child: ExperienceIntroSection(
                    experienceItem: widget.experienceItem,
                    immediateTitle: widget.experienceItem.name,
                    immediateCity: widget.experienceItem.city,
                    immediateCategoryName: widget.experienceItem.categoryName,
                    immediateSubcategoryName: widget.experienceItem.subcategoryName,
                    immediateSubcategoryIcon: widget.experienceItem.subcategoryIcon,
                  ),
                ),
              ),

              // ✅ CONTENU CHARGÉ : Avec fade + skeleton
              SliverToBoxAdapter(
                child: AnimatedOpacity(
                  opacity: _showBody ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 120),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacingM),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: AppDimensions.spacingL),

                        // ✅ Section Infos pratiques (Factory patterns)
                        ExperienceInfoSection(
                          experienceItem: widget.experienceItem,
                        ),

                        SizedBox(height: AppDimensions.spacingL),

                        // ✅ Section Description (expandable)
                        ExperienceDescriptionPanel(
                          experienceItem: widget.experienceItem,
                        ),

                        SizedBox(height: AppDimensions.spacingL),

                        // ✅ Section Recommandations (Activities seulement)
                        if (!widget.experienceItem.isEvent)
                          ActivityRecommendationsSection(
                            activityId: widget.experienceItem.id,
                            openBuilder: null,
                          ),

                        // ✅ Espace bottom pour FloatingActionBar
                        SizedBox(
                          height: MediaQuery.of(context).padding.bottom + 120,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ✅ FloatingActionBar (bottom bar)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: _showBody ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 150),
              child: ExperienceFloatingActionBar(
                experienceItem: widget.experienceItem,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ExperienceTopBar(
              categoryName: widget.experienceItem.categoryName ?? '',
              onBack: widget.onClose,
              onCategoryTap: widget.onClose,
              visible: _showTopBar,
            ),
          ),
        ],
      ),
    );
  }

  // ✅ MÉTHODES PRIVÉES (inchangées)

  void _loadExperienceDetails() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(experienceDetailProvider(widget.experienceItem).notifier)
          .loadExperienceDetails(widget.experienceItem);
    });
  }

  void _listenToHeroAnimation() {
    final routeAnimation = ModalRoute.of(context)!.animation!;
    routeAnimation.addStatusListener(_onAnimationStatusChanged);
  }

  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed && mounted) {
      print('📄 PROGRESSIVE: Animation Hero terminée → Activation progressive');

      setState(() {
        _showBody = true;
      });

      // ✅ ACCÉLÉRÉ : Activation du carousel après un délai plus court
      Future.delayed(const Duration(milliseconds: 100), () { // ✅ 200→100ms
        if (mounted) {
          print('📄 PROGRESSIVE: Activation du carousel !');
          setState(() {
            _showCarousel = true;
          });
        }
      });
    }
  }

  void _cleanupHeroListener() {
    final routeAnimation = ModalRoute.of(context)?.animation;
    routeAnimation?.removeStatusListener(_onAnimationStatusChanged);
  }

  void _onScroll() {
    final shouldShow = _scrollController.offset > 400;
    if (shouldShow != _showTopBar && mounted) {
      setState(() {
        _showTopBar = shouldShow;
      });
    }
  }
}