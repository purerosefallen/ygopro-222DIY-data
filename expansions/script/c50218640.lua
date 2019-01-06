--天星神-极限紫微
function c50218640.initial_effect(c)
    aux.EnablePendulumAttribute(c,false) 
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcFunRep(c,c50218640.ffilter,2,false)
    --special summon rule
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e0:SetRange(LOCATION_EXTRA)
    e0:SetValue(SUMMON_TYPE_FUSION)
    e0:SetCondition(c50218640.sprcon)
    e0:SetOperation(c50218640.sprop)
    c:RegisterEffect(e0)
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetRange(LOCATION_PZONE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c50218640.splimit)
    c:RegisterEffect(e1)
    --pendulum set
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c50218640.pctg)
    e2:SetOperation(c50218640.pcop)
    c:RegisterEffect(e2)
    --negate
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,50218640)
    e3:SetTarget(c50218640.negtg)
    e3:SetOperation(c50218640.negop)
    c:RegisterEffect(e3)
    --pendulum
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_DESTROYED)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCondition(c50218640.pencon)
    e4:SetTarget(c50218640.pentg)
    e4:SetOperation(c50218640.penop)
    c:RegisterEffect(e4)
end
function c50218640.spfilter(c)
    return c:IsSetCard(0xcb6) and c:IsCanBeFusionMaterial() and c:IsFaceup()
end
function c50218640.fselect(c,tp,mg,sg)
    sg:AddCard(c)
    local res=false
    if sg:GetCount()<2 then
        res=mg:IsExists(c50218640.fselect,1,sg,tp,mg,sg)
    else
        res=Duel.GetLocationCountFromEx(tp,tp,sg)>0
    end
    sg:RemoveCard(c)
    return res
end
function c50218640.sprcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local mg=Duel.GetMatchingGroup(c50218640.spfilter,tp,LOCATION_MZONE,0,nil)
    local sg=Group.CreateGroup()
    return mg:IsExists(c50218640.fselect,1,nil,tp,mg,sg) and c:IsFacedown()
end
function c50218640.sprop(e,tp,eg,ep,ev,re,r,rp,c)
    local mg=Duel.GetMatchingGroup(c50218640.spfilter,tp,LOCATION_MZONE,0,nil)
    local sg=Group.CreateGroup()
    while sg:GetCount()<2 do
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        local g=mg:FilterSelect(tp,c50218640.fselect,1,1,sg,tp,mg,sg)
        sg:Merge(g)
    end
    local cg=sg:Filter(Card.IsFacedown,nil)
    if cg:GetCount()>0 then
        Duel.ConfirmCards(1-tp,cg)
    end
    Duel.Release(sg,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c50218640.splimit(e,c)
    return not c:IsSetCard(0xcb6)
end
function c50218640.pcfilter(c)
    return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xcb6) and not c:IsForbidden()
end
function c50218640.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
        and Duel.IsExistingMatchingCard(c50218640.pcfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c50218640.pcop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local g=Duel.SelectMatchingCard(tp,c50218640.pcfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end
function c50218640.filter1(c)
    return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c50218640.filter2(c)
    return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c50218640.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return
        Duel.IsExistingMatchingCard(c50218640.filter1,tp,0,LOCATION_MZONE,1,nil)
    end
end
function c50218640.negop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(c50218640.filter2,tp,0,LOCATION_MZONE,1,nil)
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e2)
        tc=g:GetNext()
    end
end
function c50218640.pencon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c50218640.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c50218640.penop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end