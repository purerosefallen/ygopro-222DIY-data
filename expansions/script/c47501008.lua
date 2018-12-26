--极乐净土 姬塔
function c47501008.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcFunRep(c,c47501008.ffilter,3,false)
    --special summon rule
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e0:SetRange(LOCATION_EXTRA)
    e0:SetValue(SUMMON_TYPE_FUSION)
    e0:SetCondition(c47501008.sprcon)
    e0:SetOperation(c47501008.sprop)
    c:RegisterEffect(e0) 
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47501008.psplimit)
    c:RegisterEffect(e1) 
    --Damage contrl
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetCode(EFFECT_CHANGE_DAMAGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(1,0)
    e3:SetValue(c47501008.damval)
    c:RegisterEffect(e3)
    --control
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47501008,0))
    e4:SetCategory(CATEGORY_CONTROL)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetCountLimit(1,47501008+EFFECT_COUNT_CODE_OATH)
    e4:SetCost(c47501008.cost)
    e4:SetTarget(c47501008.target)
    e4:SetOperation(c47501008.operation)
    c:RegisterEffect(e4)
end
function c47501008.psplimit(e,c,tp,sumtp,sumpos)
    return not c:IsRace(RACE_WARRIOR) or c:IsRace(RACE_SPELLCASTER) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47501008.spfilter(c)
    return c:IsFusionCode(47500000) and c:IsCanBeFusionMaterial() and c:IsAbleToGraveAsCost()
end
function c47501008.fselect(c,tp,mg,sg)
    sg:AddCard(c)
    local res=false
    if sg:GetCount()<3 then
        res=mg:IsExists(c47501008.fselect,1,sg,tp,mg,sg)
    else
        res=Duel.GetLocationCountFromEx(tp,tp,sg)>0
    end
    sg:RemoveCard(c)
    return res
end
function c47501008.sprcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local mg=Duel.GetMatchingGroup(c47501008.spfilter,tp,LOCATION_EXTRA,0,nil)
    local sg=Group.CreateGroup()
    return mg:IsExists(c47501008.fselect,1,nil,tp,mg,sg)
end
function c47501008.sprop(e,tp,eg,ep,ev,re,r,rp,c)
    local mg=Duel.GetMatchingGroup(c47501008.spfilter,tp,LOCATION_EXTRA,0,nil)
    local sg=Group.CreateGroup()
    while sg:GetCount()<3 do
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local g=mg:FilterSelect(tp,c47501008.fselect,1,1,sg,tp,mg,sg)
        sg:Merge(g)
    end
    Duel.SendtoGrave(sg,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end
function c47501008.damval(e,ev,re,val,r,rp,rc)
    if bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 then return ev-1000
    else return val end
end
function c47501008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,nil,1,nil) end
    local sg=Duel.SelectReleaseGroup(tp,nil,1,1,nil)
    Duel.Release(sg,REASON_COST)
end
function c47501008.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end 
end
function c47501008.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g=Duel.SelectMatchingCard(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
    local tc=g:GetFirst()
    local c=e:GetHandler()
    if Duel.GetControl(tc,tp,PHASE_END,1)~=0 then
        Duel.NegateRelatedChain(tc,RESET_TURN_SET)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_DISABLE_EFFECT)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e3)
    end
end