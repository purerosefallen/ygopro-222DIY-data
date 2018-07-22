--Dragonlord's Approach
--Delivery
local card = c88800006
local id=88800006
function card.initial_effect(c)
    --Activation--
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(id,1)
    c:RegisterEffect(e1)
    --Normal Summon Indestructable
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e2:SetCountLimit(id,1)
    e2:SetTarget(card.indtg)
    e2:SetValue(card.indct)
    c:RegisterEffect(e2)
    --Send to GY, Special Summon from GY
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCost(card.spcost)
    e3:SetTarget(card.sptg)
    e3:SetOperation(card.spop)
    c:RegisterEffect(e3)
end

--Indestructable Set Target -- Normal Summoned and Is Dragonlord
function card.indtg(e,c)
    return c:IsSummonType(SUMMON_TYPE_NORMAL) and c:IsSetCard(0xfb0)
end
--Indestructable Set Operation -- Prevent 1 destruction 
function card.indct(e,re,r,rp)
    if bit.band(r,REASON_EFFECT)~=0 then
        return 1
    else return 0 end
end
--Sp Effect - Cost, can it be sent to GY
function card.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
     if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    e:SetLabel(e:GetHandler():GetCounter(0x1d))
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
--Sp Effect - Cost, send to GY
function card.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and card.filter(chkc,e,tp,e:GetLabel()) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(card.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,e:GetHandler():GetCounter(0x1d)) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,card.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,e:GetLabel())
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
--Sp Effect - Effect - Special Summon from GY
function card.spop(e,tc,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
--Filters 
--Draw effect discard cost - Can it be sent and is it Dragonlord -- LEGACY
function card.cfilter(c)
    return c:IsSetCard(0xfb0) and c:IsAbleToGraveAsCost()
end
--Sp effect, Is it a Dragonlord Monster that can be Special Summoned
function card.filter(c,e,tp)
    return c:IsSetCard(0xfb0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end