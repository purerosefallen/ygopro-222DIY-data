--猎犬 姬塔
function c47501007.initial_effect(c)
    aux.EnablePendulumAttribute(c,false)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcCodeFun(c,c47501007.fusfilter1,aux.FilterBoolFunction(Card.IsCode,47500000),1,true,true) 
    --special summon rule
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e0:SetRange(LOCATION_EXTRA)
    e0:SetValue(SUMMON_TYPE_FUSION)
    e0:SetCondition(c47501007.sprcon)
    e0:SetOperation(c47501007.sprop)
    c:RegisterEffect(e0)  
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47501007.psplimit)
    c:RegisterEffect(e1)
    --oiuchi
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_BATTLE_START)
    e2:SetRange(LOCATION_MZONE)
    e2:SetOperation(c47501007.tgop)
    c:RegisterEffect(e2)
    --pen swich
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetCountLimit(1,47501007)
    e3:SetCondition(c47501007.thcon)
    e3:SetTarget(c47501007.thtg)
    e3:SetOperation(c47501007.thop)
    c:RegisterEffect(e3) 
    --inactivatable
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_INACTIVATE)
    e4:SetRange(LOCATION_MZONE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e4:SetValue(c47501007.effectfilter)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_CANNOT_DISEFFECT)
    e5:SetRange(LOCATION_MZONE)
    e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e5:SetValue(c47501007.effectfilter)
    c:RegisterEffect(e5) 
    --pendulum effect
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(47501007,0))
    e6:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetRange(LOCATION_PZONE)
    e6:SetCountLimit(1,47501107)
    e6:SetTarget(c47501007.stg)
    e6:SetOperation(c47501007.sop)
    c:RegisterEffect(e6)
end
c47501007.card_code_list={47500000}
function c47501007.pefilter(c)
    return c:IsRace(RACE_WARRIOR) or c:IsRace(RACE_SPELLCASTER)
end
function c47501007.psplimit(e,c,tp,sumtp,sumpos)
    return not c47501007.pefilter(c) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47501007.fusfilter1(c)
    return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_WIND)
end
function c47501007.cfilter(c)
    return (c:IsCode(47500000) or (c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsType(TYPE_MONSTER))) and c:IsCanBeFusionMaterial() and c:IsReleasable()
end
function c47501007.spfilter1(c,tp,g)
    return g:IsExists(c47501007.spfilter2,1,c,tp,c)
end
function c47501007.spfilter2(c,tp,mc)
    return (c:IsRace(RACE_WARRIOR) and mc:IsCode(47500000) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsType(TYPE_MONSTER)
        or c:IsCode(47500000) and mc:IsRace(RACE_WARRIOR) and mc:IsAttribute(ATTRIBUTE_WIND) and mc:IsType(TYPE_MONSTER))
        and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c47501007.sprcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local g=Duel.GetMatchingGroup(c47501007.cfilter,tp,LOCATION_ONFIELD,0,nil)
    return g:IsExists(c47501007.spfilter1,1,nil,tp,g) and c:IsFacedown()
end
function c47501007.sprop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.GetMatchingGroup(c47501007.cfilter,tp,LOCATION_ONFIELD,0,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g1=g:FilterSelect(tp,c47501007.spfilter1,1,1,nil,tp,g)
    local mc=g1:GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g2=g:FilterSelect(tp,c47501007.spfilter2,1,1,mc,tp,mc)
    g1:Merge(g2)
    local cg=g1:Filter(Card.IsFacedown,nil)
    if cg:GetCount()>0 then
        Duel.ConfirmCards(1-tp,cg)
    end
    Duel.Release(g1,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end
function c47501007.effectfilter(e,ct)
    local p=e:GetHandler():GetControler()
    local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
    return p==tp and te:GetHandler():IsCode(47500000)
end
function c47501007.tgop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetAttacker()
    if tc==c then tc=Duel.GetAttackTarget() end
    if tc:IsRelateToBattle() and tc:IsDisabled() and not tc:IsType(TYPE_NORMAL) then
        local atk=tc:GetAttack()
        if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
            Duel.Damage(1-tp,atk,REASON_EFFECT)
        end
    end
end
function c47501007.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c47501007.penfilter(c)
    return c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and c:IsFaceup()
end
function c47501007.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47501007.penfilter,tp,LOCATION_PZONE,0,1,nil,e,tp,ev) end
end
function c47501007.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.GetMatchingGroup(c47501007.penfilter,tp,LOCATION_PZONE,0,nil)
    if g:GetCount()>0 and Duel.SendtoExtraP(g,nil,REASON_EFFECT) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
        local g=Duel.SelectMatchingCard(tp,c47501007.penfilter,tp,LOCATION_EXTRA,0,2,2,nil)
        local tc=g:GetFirst()
        while tc do
            Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
            tc=g:GetNext()
        end
    end
end
function c47501007.tdfilter(c)
    return c:IsType(TYPE_PENDULUM) and c:IsAbleToDeck()
end
function c47501007.tdfilter1(c)
    return c:IsType(TYPE_PENDULUM) and c:IsAbleToDeck()
end
function c47501007.stg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47501007.penfilter,tp,LOCATION_PZONE,0,1,nil,e,tp,ev) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,c47501007.tdfilter,tp,LOCATION_MZONE,0,1,1,nil)
    local g1=Duel.SelectMatchingCard(tp,c47501007.tdfilter1,tp,0,LOCATION_MZONE,1,1,nil)
    g:Merge(g1)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0) 
end
function c47501007.tdfilter1(c)
    return c:IsType(TYPE_PENDULUM) and c:IsAbleToDeck()
end
function c47501007.pspfilter(c)
    return c:IsType(TYPE_PENDULUM) and  c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47501007.pffilter(c)
    return c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and c:IsFaceup()
end
function c47501007.sop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if tg:GetCount()==2 and Duel.SendtoHand(tg,nil,REASON_EFFECT) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
        local g=Duel.SelectMatchingCard(tp,c47501007.pspfilter,tp,LOCATION_HAND,0,1,1,nil)
        local g1=Duel.SelectMatchingCard(tp,c47501007.pffilter,tp,LOCATION_EXTRA,0,1,1,nil)
        if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) then        Duel.MoveToField(g1,tp,tp,LOCATION_SZONE,POS_FACEUP,true)   
        end
    end
end