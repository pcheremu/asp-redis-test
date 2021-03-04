using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using ServiceStack.Redis;
using System;
using System.Collections.Generic;

namespace AS.Redis.Connector.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class WeatherForecastController : ControllerBase
    {
        private static readonly string[] Summaries = new[]
        {
            "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
        };

        private readonly ILogger<WeatherForecastController> _logger;
        private readonly IRedisClientsManager _redis;

        public WeatherForecastController(ILogger<WeatherForecastController> logger, IRedisClientsManager redis)
        {
            _logger = logger;
            _redis = redis;
        }

        [HttpGet]
        public IEnumerable<Weather> Get()
        {
            try
            {
                using var client = _redis.GetClient();
                var keys = client.GetAllKeys();
                var weathers = client.GetValues<Weather>(keys);
                return weathers;
            }
            catch (Exception)
            {
                return new List<Weather> {new Weather {Condition = "It works, but no connection to redis."}};
            }
        }

        [HttpPost]
        public string Post()
        {
            try
            {
                using var client = _redis.GetClient();
                client.Add(Guid.NewGuid().ToString(), new Weather
                {
                    Condition = Summaries[new Random().Next(9)]
                });

                return "ok";
            }
            catch (Exception)
            {
                return "It works, but no connection to redis.";
            }
        }
        public class Weather
        {
            public string Condition { get; set; }
        }
    }
}
