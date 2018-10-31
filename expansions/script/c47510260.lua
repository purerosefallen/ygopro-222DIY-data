--月读
local m=47510260
local cm=_G["c"..m]
function c47510260.initial_effect(c)
    aux.EnablePendulumAttribute(c,false)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcCodeFun(c,c47510260.fusfilter1,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),1,true,true)
    --special summon rule
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e0:SetRange(LOCATION_EXTRA)
    e0:SetValue(SUMMON_TYPE_FUSION)
    e0:SetCondition(c47510260.sprcon)
    e0:SetOperation(c47510260.sprop)
    c:RegisterEffect(e0)    
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47510260.psplimit)
    c:RegisterEffect(e1)  
    --pendulum effect
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47510260,0))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1,47510260)
    e2:SetCost(c47510260.mcost)
    e2:SetTarget(c47510260.mtg)
    e2:SetOperation(c47510260.mop)
    c:RegisterEffect(e2)  
    --race
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47510260,1))
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(LOCATION_MZONE+LOCATION_GRAVE+LOCATION_EXTRA,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_EXTRA)
    e3:SetCode(EFFECT_ADD_RACE)
    e3:SetValue(RACE_ZOMBIE)
    c:RegisterEffect(e3)
    --th
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47510260,2))
    e4:SetCategory(CATEGORY_TOHAND)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetCost(c47510260.thcost)
    e4:SetTarget(c47510260.thtg)
    e4:SetOperation(c47510260.thop)
    c:RegisterEffect(e4)
    --pendulum
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(47510260,3))
    e5:SetCategory(CATEGORY_DESTROY)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_DESTROYED)
    e5:SetProperty(EFFECT_FLAG_DELAY)
    e5:SetCondition(c47510260.pencon)
    e5:SetTarget(c47510260.pentg)
    e5:SetOperation(c47510260.penop)
    c:RegisterEffect(e5)
end
function c47510260.pefilter(c)
    return c:IsRace(RACE_ZOMBIE) or c:IsSetCard(0x5da) or c:IsAttribute(ATTRIBUTE_DARK)
end
function c47510260.psplimit(e,c,tp,sumtp,sumpos)
    return not c47510260.pefilter(c) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47510260.fusfilter1(c)
    return c:IsSetCard(0x5da) and c:IsType(TYPE_MONSTER)
end
function c47510260.cfilter(c)
    return (c:IsSetCard(0x5da) or c:IsRace(RACE_ZOMBIE))
        and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsReleasable()
end
function c47510260.spfilter1(c,tp,g)
    return g:IsExists(c47510260.spfilter2,1,c,tp,c)
end
function c47510260.spfilter2(c,tp,mc)
    return (c:IsSetCard(0x5da) and mc:IsRace(RACE_ZOMBIE) and c:IsType(TYPE_MONSTER)
        or c:IsRace(RACE_ZOMBIE) and mc:IsFusionSetCard(0x5da) and mc:IsType(TYPE_MONSTER))
        and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c47510260.sprcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local g=Duel.GetMatchingGroup(c47510260.cfilter,tp,LOCATION_ONFIELD,0,nil)
    return g:IsExists(c47510260.spfilter1,1,nil,tp,g)
end
function c47510260.sprop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.GetMatchingGroup(c47510260.cfilter,tp,LOCATION_ONFIELD,0,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g1=g:FilterSelect(tp,c47510260.spfilter1,1,1,nil,tp,g)
    local mc=g1:GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g2=g:FilterSelect(tp,c47510260.spfilter2,1,1,mc,tp,mc)
    g1:Merge(g2)
    local cg=g1:Filter(Card.IsFacedown,nil)
    if cg:GetCount()>0 then
        Duel.ConfirmCards(1-tp,cg)
    end
    Duel.Release(g1,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end
function c47510260.mcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler() end
    Duel.SendtoExtraP(e:GetHandler(),nil,0,REASON_COST)
end
function c47510260.spfilter(c,e,tp)
    return c:IsRace(RACE_ZOMBIE) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47510260.mtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c47510260.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c47510260.mop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c47510260.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
        e1:SetValue(0)
        tc:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
        tc:RegisterEffect(e2)
        Duel.SpecialSummonComplete()
    end
end
function c47510260.thfilter(c)
    return c:IsRace(RACE_ZOMBIE) and c:IsAbleToHand()
end
function c47510260.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,c47510260.thfilter,1,nil,tp) and Duel.CheckReleaseGroup(1-tp,c47510260.thfilter,1,nil,tp) end
    local g1=Duel.GetReleaseGroup(tp):Filter(c47510260.thfilter,nil,tp)
    local g2=Duel.GetReleaseGroup(1-tp):Filter(c47510260.thfilter,nil,tp)
    g1:Merge(g2)
    local tc=g1:Select(tp,1,1,nil):GetFirst()
    Duel.Release(tc,REASON_COST)
end
function c47510260.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47510260.thfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c47510260.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c47510260.thfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,tp,REASON_EFFECT) 
    end
end
function c47510260.pencon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c47510260.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)>0 end
    local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c47510260.penop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
    if Duel.Destroy(g,REASON_EFFECT)~=0 and e:GetHandler():IsRelateToEffect(e) then
        Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end