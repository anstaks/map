#= require jquery
#= require jquery_ujs
init = ->
  myMap = new (ymaps.Map)('map',
    center: [55.74, 37.58]
    zoom: 11
    controls: []
  )

  myMap.events.add 'click', (e) ->
    myMap.geoObjects.removeAll()

    circleGeometry = new (ymaps.geometry.Circle)(
      e.get('coords')
      5000
    )

    myCircle = new (ymaps.GeoObject)(
      geometry: circleGeometry
    )

    myMap.geoObjects.add myCircle

    ymaps.search(
      'кафе'
      results: 50
      boundedBy: circleGeometry.getBounds()
    ).then (result) ->
      $("#addresses").remove();
      $("body").append('<table id="addresses"></table>')
      result.geoObjects.each (el, i) ->
        coords = el.geometry.getCoordinates()
        if circleGeometry.contains coords
          myMap.geoObjects.add(new ymaps.Placemark(coords, { balloonContent: el.properties._te.address});)
          createMenuGroup(el, ymaps.coordSystem.geo.getDistance(circleGeometry.getCoordinates(), coords))



ymaps.ready init

createMenuGroup = (el, distance) ->
  name = el.properties._te.name
  address = el.properties._te.address
  menuItem = $('<tr><td>' + name + '</td><td>' + address + '</td><td>' + Math.ceil(distance) + ' метров от центра круга</td></tr>')
  menuItem.appendTo($('#addresses'));
