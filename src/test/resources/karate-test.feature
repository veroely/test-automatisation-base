Feature: Test de API súper simple

  Background:
    * configure ssl = true
    * def baseUrlMarvel = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api'

  Scenario: Verificar que un endpoint público responde 200
    Given url 'https://httpbin.org/get'
    When method get
    Then status 200

  @GetAllCharactersMarvel
  Scenario: Obtener todos los personajes
    Given  url baseUrlMarvel +'/characters'
    When method get
    Then status 200

  @GetCharactersByIdSuccess
  Scenario: Obtener personaje por ID
    Given url baseUrlMarvel + '/characters/16'
    When method get
    Then status 200
#    Examples:
#      | characterId |
#      | 999         |
#      | 1           |
  @GetCharactersByIdNotFound
  Scenario: Obtener personaje por ID
    Given url baseUrlMarvel + '/characters/999'
    When method get
    Then status 404
    And match response.error == 'Character not found'