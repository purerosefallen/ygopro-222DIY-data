--黑猫道士 姬塔
function c47500015.initial_effect(c)
    c:EnableCounterPermit(0x1)
    c:EnableReviveLimit()
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --activate
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(47500015,0))
    e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e0:SetType(EFFECT_TYPE_IGNITION)
    e0:SetRange(LOCATION_PZONE)
    e0:SetCountLimit(1,47500014)
    e0:SetTarget(c47500015.target)
    e0:SetOperation(c47500015.activate)
    c:RegisterEffect(e0)    
    --kuroneko
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetCode(EFFECT_ADD_RACE)
    e1:SetRange(LOCATION_ONFIELD+LOCATION_EXTRA+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
    e1:SetValue(RACE_BEASTWARRIOR)
    c:RegisterEffect(e1)
    --moon magic
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DAMAGE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_ATTACK_ANNOUNCE)
    e2:SetOperation(c47500015.actop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_BE_BATTLE_TARGET)
    c:RegisterEffect(e3)
    --Activate
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47500015,1))
    e4:SetCategory(CATEGORY_COUNTER)
    e4:SetType(EFFECT_TYPE_IGNITION)  
    e4:SetCountLimit(1)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCost(c47500015.mncost)
    e4:SetOperation(c47500015.mnop)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_TOHAND)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EVENT_BATTLE_END)
    e5:SetCondition(c47500015.damcon)
    e5:SetOperation(c47500015.damop)
    c:RegisterEffect(e5)
    --special summon
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(47500015,2))
    e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetCountLimit(1,47500015)
    e6:SetRange(LOCATION_MZONE)
    e6:SetTarget(c47500015.sptg)
    e6:SetOperation(c47500015.spop)
    c:RegisterEffect(e6)
end
c47500015.card_code_list={47500000}
function c47500015.mfilter(c)
    return c:IsCode(47500000) and c:IsFaceup()
end
function c47500015.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(c47500015.mfilter,tp,LOCATION_EXTRA,0,2,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c47500015.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local c=e:GetHandler()
    local g=Duel.SelectMatchingCard(tp,c47500015.mfilter,tp,LOCATION_EXTRA,0,2,2,nil)
    if Duel.SendtoGrave(g,REASON_COST) then
        Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
        c:CompleteProcedure()
    end
end
function c47500015.actop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetValue(c47500015.efilter)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_EXTRA_ATTACK)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetValue(1)
    e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
end
function c47500015.efilter(e,te)
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c47500015.mncost(e,tp,eg,ep,ev,re,r,rp,chk,val)
    if chk==0 then return true end
    local val=e:SetLabel(math.floor(Duel.GetLP(tp)/2))
    Duel.PayLPCost(tp,e:GetLabel())
end
function c47500015.mnop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ct=e:GetLabel()/500
    c:AddCounter(0x1,ct)
end
function c47500015.damcon(e)
    local c=e:GetHandler()
    return c:GetBattleTarget()~=nil
end
function c47500015.damop(e,tp,eg,ep,ev,re,r,rp)
    local mp=c:GetCounter(0x1)*1
    Duel.Damage(1-tp,mp*400,REASON_EFFECT)
end
function c47500015.filter(c,cc,e,tp)
    return c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetLevel()>0 and c:IsType(TYPE_PENDULUM) and cc:IsCanRemoveCounter(tp,0x1,c:GetLevel(),REASON_COST)
end
function c47500015.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c47500015.filter,tp,LOCATION_DECK,0,1,nil,e:GetHandler(),e,tp) end
    local g=Duel.GetMatchingGroup(c47500015.filter,tp,LOCATION_DECK,0,nil,e:GetHandler(),e,tp)
    local lvt={}
    local tc=g:GetFirst()
    while tc do
        local tlv=tc:GetLevel()
        lvt[tlv]=tlv
        tc=g:GetNext()
    end
    local pc=1
    for i=1,12 do
        if lvt[i] then lvt[i]=nil lvt[pc]=i pc=pc+1 end
    end
    lvt[pc]=nil
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(47500015,1))
    local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
    Duel.RemoveCounter(tp,1,1,0x1,lv,REASON_COST)
    e:SetLabel(lv)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c47500015.sfilter(c,lv,e,tp)
    return c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevel(lv)
end
function c47500015.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local lv=e:GetLabel()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47500015.sfilter,tp,LOCATION_DECK,0,1,1,nil,lv,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end