@ApiMarvel
Feature: Test de APIsMarvel

  Background:
    * configure ssl = true
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api'

  @id:1 @GetAllCharactersMarvel
  Scenario: Obtener todos los personajes
    Given path '/characters'
    When method get
    Then status 200

  @id:2 @GetCharactersByIdSuccess
  Scenario Outline: Obtener personaje por ID <characterId>
    Given path '/characters/<characterId>'
    When method get
    Then status 200
    Examples:
      | characterId |
      | 2621        |
      | 2622        |

  @id:3 @GetCharactersByIdNotFound
  Scenario: Obtener personaje por ID
    Given path '/characters/999'
    When method get
    Then status 404
    And match response.error == 'Character not found'

    # CREATE
  @id:4 @CreateCharacterSuccess
  Scenario Outline: Crear personaje
    * def requestBody = read('classpath:../data/marvel/character-create.json')
    Given path '/characters'
    And request requestBody
    When method post
    Then status 201
    * print response.id
    Examples:
        |  read('classpath:../data/marvel/characters-create.csv')|

  @id:5 @CreateCharacterDuplicate
  Scenario Outline: Crear personaje duplicado
    * def requestBody = read('classpath:../data/marvel/character-create.json')
    Given path '/characters'
    And request requestBody
    When method post
    Then status 400
    And match response.error == 'Character name already exists'
    Examples:
      |  read('classpath:../data/marvel/characters-create.csv')|

  @id:6 @CreateCharacterValidateFields
  Scenario: Validar campos al crear personaje
    * def requestBody = read('classpath:../data/marvel/character-create-validate-fields.json')
    Given path '/characters'
    And request requestBody
    When method post
    Then status 400
    * print response
    And match response.name == 'Name is required'

  # UPDATE
  @id:7 @PutCharacterSuccess
  Scenario: Actualizar personaje
    * def requestBody = read('classpath:../data/marvel/character-update.json')
    Given path '/characters/2621'
    And request requestBody
    When method put
    Then status 200
    And match response.name == 'Verónica Vicente'

  @id:8 @PutCharacterNotFound
  Scenario: Actualiza personaje que no existe
    * def requestBody = read('classpath:../data/marvel/character-update.json')
    Given path '/characters/1'
    And request requestBody
    When method put
    Then status 404
    And match response.error == 'Character not found'

     #DELETE
  @id:9 @DeleteCharacterSuccess
  Scenario Outline: Eliminar personaje
    Given path '/characters/<characterId>'
    When method delete
    Then status 204
    When method delete
    Then status 204
    Examples:
      | characterId |
      | 2771        |
      | 2772        |

  @id:10 @DeleteCharacterNotFound
  Scenario: Eliminar personaje que no existe
    Given path '/characters/1'
    When method delete
    Then status 404