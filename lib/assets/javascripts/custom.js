/* JS Document */

/******************************

[Table of Contents]

1. Vars and Inits
2. Set Header
3. Init Home Slider
4. Init Search
5. Init Menu
6. Init Isotope
7. Init Quantity
8. Init Image
9. Init Google Map


******************************/

$(document).ready(function()
{
	"use strict";

	/* 

	1. Vars and Inits

	*/

	var header = $('.header');
	var hambActive = false;
	var menuActive = false;

	setHeader();

	$(window).on('resize', function()
	{
		setHeader();
	});

	$(document).on('scroll', function()
	{
		setHeader();
	});

	initHomeSlider();
	initSearch();
	initMenu();
	initIsotope();

	/* 

	2. Set Header

	*/

	function setHeader()
	{
		if($(window).scrollTop() > 100)
		{
			header.addClass('scrolled');
		}
		else
		{
			header.removeClass('scrolled');
		}
	}

	/* 

	3. Init Home Slider

	*/

	function initHomeSlider()
	{
		if($('.home_slider').length)
		{
			var homeSlider = $('.home_slider');
			homeSlider.owlCarousel(
			{
				items:1,
				autoplay:true,
				autoplayTimeout:10000,
				loop:true,
				nav:false,
				smartSpeed:1200,
				dotsSpeed:1200,
				fluidSpeed:1200
			});

			/* Custom dots events */
			if($('.home_slider_custom_dot').length)
			{
				$('.home_slider_custom_dot').on('click', function()
				{
					$('.home_slider_custom_dot').removeClass('active');
					$(this).addClass('active');
					homeSlider.trigger('to.owl.carousel', [$(this).index(), 1200]);
				});
			}

			/* Change active class for dots when slide changes by nav or touch */
			homeSlider.on('changed.owl.carousel', function(event)
			{
				$('.home_slider_custom_dot').removeClass('active');
				$('.home_slider_custom_dots li').eq(event.page.index).addClass('active');
			});

			// add animate.css class(es) to the elements to be animated
			function setAnimation ( _elem, _InOut )
			{
				// Store all animationend event name in a string.
				// cf animate.css documentation
				var animationEndEvent = 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend';

				_elem.each ( function ()
				{
					var $elem = $(this);
					var $animationType = 'animated ' + $elem.data( 'animation-' + _InOut );

					$elem.addClass($animationType).one(animationEndEvent, function ()
					{
						$elem.removeClass($animationType); // remove animate.css Class at the end of the animations
					});
				});
			}

			// Fired before current slide change
			homeSlider.on('change.owl.carousel', function(event)
			{
				var $currentItem = $('.home_slider_item', homeSlider).eq(event.item.index);
				var $elemsToanim = $currentItem.find("[data-animation-out]");
				setAnimation ($elemsToanim, 'out');
			});

			// Fired after current slide has been changed
			homeSlider.on('changed.owl.carousel', function(event)
			{
				var $currentItem = $('.home_slider_item', homeSlider).eq(event.item.index);
				var $elemsToanim = $currentItem.find("[data-animation-in]");
				setAnimation ($elemsToanim, 'in');
			})
		}
	}

	/* 

	4. Init Search

	*/

	function initSearch()
	{
		if($('.search').length && $('.search_panel').length)
		{
			var search = $('.search');
			var panel = $('.search_panel');

			search.on('click', function()
			{
				panel.toggleClass('active');
			});
		}
	}

	/* 

	5. Init Menu

	*/

	function initMenu()
	{
		if($('.hamburger').length)
		{
			var hamb = $('.hamburger');

			hamb.on('click', function(event)
			{
				event.stopPropagation();

				if(!menuActive)
				{
					openMenu();
					
					$(document).one('click', function cls(e)
					{
						if($(e.target).hasClass('menu_mm'))
						{
							$(document).one('click', cls);
						}
						else
						{
							closeMenu();
						}
					});
				}
				else
				{
					$('.menu').removeClass('active');
					menuActive = false;
				}
			});

			//Handle page menu
			if($('.page_menu_item').length)
			{
				var items = $('.page_menu_item');
				items.each(function()
				{
					var item = $(this);

					item.on('click', function(evt)
					{
						if(item.hasClass('has-children'))
						{
							evt.preventDefault();
							evt.stopPropagation();
							var subItem = item.find('> ul');
						    if(subItem.hasClass('active'))
						    {
						    	subItem.toggleClass('active');
								TweenMax.to(subItem, 0.3, {height:0});
						    }
						    else
						    {
						    	subItem.toggleClass('active');
						    	TweenMax.set(subItem, {height:"auto"});
								TweenMax.from(subItem, 0.3, {height:0});
						    }
						}
						else
						{
							evt.stopPropagation();
						}
					});
				});
			}
		}
	}

	function openMenu()
	{
		var fs = $('.menu');
		fs.addClass('active');
		hambActive = true;
		menuActive = true;
	}

	function closeMenu()
	{
		var fs = $('.menu');
		fs.removeClass('active');
		hambActive = false;
		menuActive = false;
	}

	/* 

	6. Init Isotope

	*/

	function initIsotope()
	{
		var sortingButtons = $('.product_sorting_btn');
		var sortNums = $('.num_sorting_btn');

		if($('.product_grid').length)
		{
			var grid = $('.product_grid').isotope({
				itemSelector: '.product',
				layoutMode: 'fitRows',
				fitRows:
				{
					gutter: 30
				},
	            getSortData:
	            {
	            	price: function(itemElement)
	            	{
	            		var priceEle = $(itemElement).find('.product_price').text().replace( '$', '' );
	            		return parseFloat(priceEle);
	            	},
	            	name: '.product_name',
	            	stars: function(itemElement)
	            	{
	            		var starsEle = $(itemElement).find('.rating');
	            		var stars = starsEle.attr("data-rating");
	            		return stars;
	            	}
	            },
	            animationOptions:
	            {
	                duration: 750,
	                easing: 'linear',
	                queue: false
	            }
	        });
		}
	}

	/* 

	7. Init Quantity

	*/

function initQuantity() {
	// Handle product quantity input
	if ($('.product_quantity').length) {
		var input = $('#quantity_input');
		var incButton = $('#quantity_inc_button');
		var decButton = $('#quantity_dec_button');

		var originalVal;
		var endVal;

		incButton.on('click', function () {
			originalVal = input.val();
			endVal = parseFloat(originalVal) + 1;
			input.val(endVal);
		});

		decButton.on('click', function () {
			originalVal = input.val();
			if (originalVal > 0) {
				endVal = parseFloat(originalVal) - 1;
				input.val(endVal);
			}
		});
	}
}

	/* 

	8. Init Image

	*/

	function initImage() {
		var images = $('.details_image_thumbnail');
		var selected = $('.details_image_large img');

		images.each(function () {
			var image = $(this);
			image.on('click', function () {
				var imagePath = new String(image.data('image'));
				selected.attr('src', imagePath);
				images.removeClass('active');
				image.addClass('active');
			});
		});
	}

		/* 

	9. Init Google Map

	*/

		function initGoogleMap() {
			var myLatlng = new google.maps.LatLng(34.043238, -118.258338);
			var mapOptions = {
				center: myLatlng,
				zoom: 13,
				mapTypeId: google.maps.MapTypeId.ROADMAP,
				draggable: true,
				scrollwheel: false,
				zoomControl: true,
				zoomControlOptions: {
					position: google.maps.ControlPosition.RIGHT_CENTER
				},
				mapTypeControl: false,
				scaleControl: false,
				streetViewControl: false,
				rotateControl: false,
				fullscreenControl: true,
				styles: [{
						"featureType": "landscape",
						"elementType": "geometry.fill",
						"stylers": [{
							"color": "#e9e5dc"
						}]
					},
					{
						"featureType": "poi",
						"elementType": "labels",
						"stylers": [{
							"visibility": "off"
						}]
					},
					{
						"featureType": "road",
						"elementType": "labels.icon",
						"stylers": [{
							"visibility": "off"
						}]
					},
					{
						"featureType": "road.arterial",
						"elementType": "geometry",
						"stylers": [{
							"weight": 1.5
						}]
					},
					{
						"featureType": "road.arterial",
						"elementType": "geometry.fill",
						"stylers": [{
							"weight": 1
						}]
					},
					{
						"featureType": "road.highway",
						"elementType": "geometry.fill",
						"stylers": [{
							"color": "#fa9e25"
						}]
					},
					{
						"featureType": "road.highway",
						"elementType": "geometry.stroke",
						"stylers": [{
							"color": "#e49307"
						}]
					},
					{
						"featureType": "road.highway",
						"elementType": "labels",
						"stylers": [{
							"visibility": "off"
						}]
					},
					{
						"featureType": "road.local",
						"elementType": "geometry",
						"stylers": [{
							"weight": 0.5
						}]
					},
					{
						"featureType": "road.local",
						"elementType": "geometry.fill",
						"stylers": [{
							"color": "#d9d4ca"
						}]
					},
					{
						"featureType": "transit",
						"elementType": "labels",
						"stylers": [{
							"visibility": "off"
						}]
					}
				]
			}

			// Initialize a map with options
			map = new google.maps.Map(document.getElementById('map'), mapOptions);

			// Re-center map after window resize
			google.maps.event.addDomListener(window, 'resize', function () {
				setTimeout(function () {
					google.maps.event.trigger(map, "resize");
					map.setCenter(myLatlng);
				}, 1400);
			});
		}

});