--露☆娜☆酱
function c47552431.initial_effect(c)
    aux.EnablePendulumAttribute(c)
    c:EnableCounterPermit(0x1,LOCATION_PZONE+LOCATION_MZONE)  
    --pendulum set
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1,47552431)
    e1:SetCondition(c47552431.pencon)
    e1:SetTarget(c47552431.pentg)
    e1:SetOperation(c47552431.penop)
    c:RegisterEffect(e1) 
    --add counter
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_PZONE+LOCATION_MZONE)
    e2:SetOperation(aux.chainreg)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e3:SetCode(EVENT_CHAIN_SOLVED)
    e3:SetRange(LOCATION_PZONE+LOCATION_MZONE)
    e3:SetOperation(c47552431.acop)
    c:RegisterEffect(e3)
    --serch
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_SUMMON_SUCCESS)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCountLimit(1,47552432)
    e4:SetCost(c47552431.tgcost)
    e4:SetTarget(c47552431.tgtg)
    e4:SetOperation(c47552431.tgop)
    c:RegisterEffect(e4)
end
function c47552431.pencon(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(nil,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function c47552431.penfilter(c)
    return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_SPELLCASTER) and c:IsLevel(8) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c47552431.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDestructable()
        and Duel.IsExistingMatchingCard(c47552431.penfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c47552431.penop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
        local g=Duel.SelectMatchingCard(tp,c47552431.penfilter,tp,LOCATION_DECK,0,1,1,nil)
        local tc=g:GetFirst()
        if tc then
            Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        end
    end
end
function c47552431.acop(e,tp,eg,ep,ev,re,r,rp)
    if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and e:GetHandler():GetFlagEffect(1)>0 then
        e:GetHandler():AddCounter(0x1,2)
    end
end
function c47552431.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1,4,REASON_COST) end
    Duel.RemoveCounter(tp,1,0,0x1,4,REASON_COST)
end
function c47552431.tgfilter(c)
    return c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsLevelAbove(4) and c:IsAbleToGrave()
end
function c47552431.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47552431.filter,tp,LOCATION_DECK,0,1,nil,tp) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_DECK)
end
function c47552431.tgop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c47552431.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then 
        Duel.Destroy(g,REASON_EFFECT,LOCATION_GRAVE)
    end
end