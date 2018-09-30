--必然的命运-伊莉雅
local m=4231001
local cm=_G["c"..m]
function cm.initial_effect(c)
    iFunc(c).c("RegisterEffect",iFunc(c)
        .e("SetCategory",CATEGORY_TOGRAVE+CATEGORY_TOHAND)
        .e("SetType",EFFECT_TYPE_QUICK_O)
        .e("SetCode",EVENT_FREE_CHAIN)
        .e("SetRange",LOCATION_MZONE)
        .e("SetCost",function(e,tp,eg,ep,ev,re,r,rp,chk)--return to hand as cost
            if chk==0 then return e:GetHandler():IsAbleToHandAsCost() end
            Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
        end)
        .e("SetTarget",function(e,tp,eg,ep,ev,re,r,rp,chk)--if normal spellcaster is onfield
            if chk==0 then return iCount(0,tp,m,1) 
                and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_DECK,0,1,nil,4231007) end
Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
            if Duel.IsExistingMatchingCard(cm.mfilter,tp,LOCATION_MZONE,0,1,nil) then
                Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
            end
            Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_DECK)
        end)
        .e("SetOperation",function(e,tp,eg,ep,ev,re,r,rp)--choose if add to hand
            local g = Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_DECK,0,1,1,nil,4231007)
            if Duel.IsExistingMatchingCard(cm.mfilter,tp,LOCATION_MZONE,0,1,nil)  then
                if Duel.SelectYesNo(tp,aux.Stringid(m,0)) and g:GetFirst():IsAbleToHand() then 
                    Duel.SendtoHand(g,nil,REASON_EFFECT) 
                    Duel.ConfirmCards(1-tp,g) else Duel.SendtoGrave(g,REASON_EFFECT)  
                end
            else                
                Duel.SendtoGrave(g,REASON_EFFECT)
            end
        end)
    .Return()).c("RegisterEffect",iFunc(c)
        .e("SetCategory",CATEGORY_SPECIAL_SUMMON)
        .e("SetType",EFFECT_TYPE_IGNITION)
        .e("SetRange",LOCATION_HAND)
        .e("SetProperty",EFFECT_FLAG_CARD_TARGET)
        .e("SetTarget",function(e,tp,eg,ep,ev,re,r,rp,chk)
            if chk==0 then return iCount(0,tp,m,2) 
                and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,4231006)  
                and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) 
                and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
                and Duel.GetLocationCount(tp,LOCATION_SZONE)>0  end
Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
            local g=Duel.SelectTarget(tp,Card.IsCode,tp,LOCATION_GRAVE,0,1,1,nil,4231006)
            Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)            
        end)
        .e("SetOperation",function(e,tp,eg,ep,ev,re,r,rp)
            if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,4231006) and e:GetHandler():IsLocation(LOCATION_HAND) then
                if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP) then
                    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
                    local tc=Duel.GetFirstTarget()
                    Duel.Equip(tp,tc,e:GetHandler())
                end                
            end            
        end)
    .Return())
end
function cm.cfilter(c,code)
    return c:IsCode(code) and (c:IsAbleToGrave() or (c:IsAbleToHand() and Duel.IsExistingMatchingCard(cm.mfilter,tp,LOCATION_MZONE,0,1,nil)))
end
function cm.mfilter(c)
    return c:IsType(TYPE_NORMAL) and c:IsRace(RACE_SPELLCASTER) and c:IsFaceup()
end
function iCount(name,tp,m,id)
    return ((name=="get" or name=="set")
        and {(name=="get"
            and {tonumber(((Duel.GetFlagEffect(tp,m)==nil) and {0} or {Duel.GetFlagEffect(tp,m)})[1])} 
            or { Debug.Message("","请使用Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)") })[1]}
        or {(bit.band(iCount("get",tp,m,id),math.pow(2,id-1))==0 and {true} or {false})[1]})[1]
end
function iFunc(c,x)
    local __this = (aux.GetValueType(c) == "Card" and {(x == nil and {Effect.CreateEffect(c)} or {x})[1]} or {x})[1] 
    local fe = function(name,...) (type(__this[name])=="function" and {__this[name]} or {""})[1](__this,...) return iFunc(c,__this) end
    local fc = function(name,...) this = (type(c[name])=="function" and {c[name]} or {""})[1](c,...) return iFunc(c,c) end  
    local func ={e = fe,c = fc,g = fc,v = function() return this end,Return = function() return __this:Clone() end}
    return func
end