Get a todo list ChatGPT plugin up and running in under 5 minutes using Python. If you do not already have plugin developer access, please [join the waitlist](https://openai.com/waitlist/plugins).

- 开发文档：https://community.openai.com/c/chat-plugins/20
- 快速开始源码库：https://github.com/openai/plugins-quickstart
- weathergpt：https://github.com/steven-tey/weathergpt

```requirements.txt
quart
quart-cors
```

```openapi.yaml
openapi: 3.0.1
info:
  title: QEEQ
  description: Founded in 2017, we provide services to tens of millions of travelers every year. Our mission is to make journeys more enjoyable and bring better travel experiences to QEEQ with the help of technology.
  version: 'v1'
servers:
  - url: "{$MY_BASE_URL}"
paths:
  /revision/aigc/chatgpt/list:
    post:
      operationId: revisionList
      summary: Search car rentals on a route for certain dates
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/RevisionListRequest'
      responses:
        "200":
          description: OK
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/RevisionListResponse'
        "404":
          description: Not found
        "429":
          description: Rate limited

components:
  schemas:
    RevisionListRequest:
      type: object
      properties:
        pickup_lng:
          type: string
          description: The pickup longitude from which the route starts, like 113.380721.
          required: true
        pickup_lat:
          type: string
          description: The pickup latitude from which the route starts, like 23.098035.
          required: true
        from_date_0:
          type: string
          description: The pickup date from which the route starts, like 2023-06-22.
          required: true
        from_date_1:
          type: string
          description: The pickup time from which the route starts, like 10:00.
          required: true
        to_date_0:
          type: string
          description: The dropoff date from which the route goes, like 2023-06-23.
          required: true
        to_date_1:
          type: string
          description: The dropoff date from which the route goes, like 10:00.
          required: true
        dropoff_lng:
          type: string
          description: The dropoff longitude to which the route goes.
          required: true
        dropoff_lat:
          type: string
          description: The dropoff latitude to which the route goes.
          required: true
        citizen_country_code:
          type: string
          description: User's nationality two character code, like AU.
          required: true
        payment:
          type: string
          description: Payment method. Ignore if not mentioned.
          enum:
            - postpaid
            - prepaid
            - partpaid
          required: false
        group:
          type: string
          description: First level vehicle selection. Ignore if not mentioned.
          enum:
            - small
            - medium
            - large
            - suv
            - pickup_truck
            - van
            - convertible
            - eco
            - unspecified
            - premium
          required: false
        seat:
          type: number
          description: Number of seats in the car. Ignore if not mentioned.
          required: false
        currency:
          type: string
          description: Currency three character code, like AUD. Ignore if not mentioned.
          required: false
        lang:
          type: string
          description: Language Two Character Code, like ko. Ignore if not mentioned.
          required: false
        utm_source:
          type: string
          description: Fixed as aigc.
          required: true
        utm_medium:
          type: string
          description: Fixed as chatgpt.
          required: true

    RevisionListResponse:
      type: object
      properties:
        data:
          type: object
          description: Data of response.
          properties:
            list:
              type: array
              description: List of car rental infos.
              items:
                $ref: "#/components/schemas/RevisionListItem"

    RevisionListItem:
      type: object
      properties:
        dealer_name:
          type: string
          description: Car dealership name.
        dealer_logo:
          type: string
          description: Car dealership logo.
        car_name:
          type: string
          description: Car name.
        car_image:
          type: string
          description: Vehicle image.
        car_type:
          type: string
          description: Car Model name.
        price:
          type: string
          description: Price.
        book_url:
          type: string
          description: Order Link.
        payment_type:
          type: string
          description: Payment Type.
        seat:
          type: string
          description: Number of seats in the car.
        is_electric_vehicle:
          type: boolean
          description: Is it a tram.
        is_hybrid_vehicle:
          type: boolean
          description: Is it a hybrid vehicle.
        luggage:
          type: string
          description: Number of bags.
        car_door:
          type: string
          description: Number of car doors.
        transmission_name:
          type: string
          description: Transmission name.
```

```.well-known/ai-plugin.json
{
    "schema_version": "v1",
    "name_for_human": "QEEQ",
    "name_for_model": "QEEQ",
    "description_for_human": "Our mission is to make journeys more enjoyable and bring better travel experiences to QEEQ with the help of technology.",
    "description_for_model": "Founded in 2017, we provide services to tens of millions of travelers every year. Our mission is to make journeys more enjoyable and bring better travel experiences to QEEQ with the help of technology.",
    "auth": {
      "type": "none"
    },
    "api": {
      "type": "openapi",
      "url": "{$MY_BASE_URL}/openapi.yaml",
      "is_user_authenticated": false
    },
    "logo_url": "{$MY_BASE_URL}/logo.png",
    "contact_email": "support@qeeq.com",
    "legal_info_url": "https://www.qeeq.com/term?info=privacypolicy"
  }
```


Once the local server is running:

1. Navigate to https://chat.openai.com.
2. In the Model drop down, select "Plugins" (note, if you don't see it there, you don't have access yet).
3. Select "Plugin store"
4. Select "Develop your own plugin"
5. Enter in localhost:8000 since this is the URL the server is running on locally, then select "Find manifest file".

The plugin should now be installed and enabled! You can start with a question like "What is on my todo list" and then try adding something to it as well!