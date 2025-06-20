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


  @CreateCharacterSuccess
  Scenario Outline: Crear personaje
    * def requestBody = read('classpath:../data/character-create.json')
    Given url baseUrlMarvel + '/characters'
    And request requestBody
    When method post
    Then status 201
    * print response
    Examples:
        |  read('classpath:../data/characters-create.csv')|

  @CreateCharacterDuplicate
  Scenario: Crear personaje duplicado
    * def requestBody = read('classpath:../data/character-create.json')
    Given url baseUrlMarvel + '/characters'
    And request requestBody
    When method post
    Then status 400
    And match response.error == 'Character name already exists'

  @CreateCharacterValidateFields
  Scenario: Validar campos al crear personaje
    * def requestBody = read('classpath:../data/character-create-validate-fields.json')
    Given url baseUrlMarvel + '/characters'
    And request requestBody
    When method post
    Then status 400
    * print response
    And match response.name == 'Name is required'


  @PutCharacterSuccess
  Scenario: Actualizar personaje
    * def requestBody = read('classpath:../data/character-update.json')
    Given url baseUrlMarvel + '/characters/553'
    And request requestBody
    When method put
    Then status 200
    And match response.name == 'Verónica Vicente'

  @PutCharacterNotFound
  Scenario: Actualiza personaje que no existe
    * def requestBody = read('classpath:../data/character-update.json')
    Given url baseUrlMarvel + '/characters/1'
    And request requestBody
    When method put
    Then status 404
    And match response.error == 'Character not found'


  @DeleteCharacterSuccess
  Scenario: Eliminar personaje
    Given url baseUrlMarvel + '/characters/1314'
    When method delete
    Then status 204

  @DeleteCharacterNotFound
  Scenario: Eliminar personaje que no existe
    Given url baseUrlMarvel + '/characters/1'
    When method delete
    Then status 404