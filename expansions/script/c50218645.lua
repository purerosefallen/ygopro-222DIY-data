--天星神-闪耀比邻
function c50218645.initial_effect(c)
    aux.EnablePendulumAttribute(c,false) 
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcFunRep(c,c50218645.ffilter,3,false)
    --special summon rule
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e0:SetRange(LOCATION_EXTRA)
    e0:SetValue(SUMMON_TYPE_FUSION)
    e0:SetCondition(c50218645.sprcon)
    e0:SetOperation(c50218645.sprop)
    c:RegisterEffect(e0)
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetRange(LOCATION_PZONE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c50218645.splimit)
    c:RegisterEffect(e1)
    --destroy replace
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_DESTROY_REPLACE)
    e2:SetRange(LOCATION_PZONE)
    e2:SetTarget(c50218645.reptg)
    e2:SetValue(c50218645.repval)
    e2:SetOperation(c50218645.repop)
    c:RegisterEffect(e2)
    --remove
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_REMOVE)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,50218645)
    e3:SetTarget(c50218645.retg)
    e3:SetOperation(c50218645.reop)
    c:RegisterEffect(e3)
    --pendulum
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_LEAVE_FIELD)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCondition(c50218645.pencon)
    e4:SetTarget(c50218645.pentg)
    e4:SetOperation(c50218645.penop)
    c:RegisterEffect(e4)
end
function c50218645.spfilter(c)
    return c:IsSetCard(0xcb6) and c:IsCanBeFusionMaterial() and c:IsFaceup()
end
function c50218645.fselect(c,tp,mg,sg)
    sg:AddCard(c)
    local res=false
    if sg:GetCount()<3 then
        res=mg:IsExists(c50218645.fselect,1,sg,tp,mg,sg)
    else
        res=Duel.GetLocationCountFromEx(tp,tp,sg)>0
    end
    sg:RemoveCard(c)
    return res
end
function c50218645.sprcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local mg=Duel.GetMatchingGroup(c50218645.spfilter,tp,LOCATION_MZONE,0,nil)
    local sg=Group.CreateGroup()
    return mg:IsExists(c50218645.fselect,1,nil,tp,mg,sg)
end
function c50218645.sprop(e,tp,eg,ep,ev,re,r,rp,c)
    local mg=Duel.GetMatchingGroup(c50218645.spfilter,tp,LOCATION_MZONE,0,nil)
    local sg=Group.CreateGroup()
    while sg:GetCount()<3 do
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        local g=mg:FilterSelect(tp,c50218645.fselect,1,1,sg,tp,mg,sg)
        sg:Merge(g)
    end
    local cg=sg:Filter(Card.IsFacedown,nil)
    if cg:GetCount()>0 then
        Duel.ConfirmCards(1-tp,cg)
    end
    Duel.Release(sg,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c50218645.splimit(e,c)
    return not c:IsSetCard(0xcb6)
end
function c50218645.repfilter(c,tp)
    return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsSetCard(0xcb6)
        and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp)) and not c:IsReason(REASON_REPLACE)
end
function c50218645.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return eg:IsExists(c50218645.repfilter,1,c,tp)
        and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED) end
    return Duel.SelectEffectYesNo(tp,c,96)
end
function c50218645.repval(e,c)
    return c50218645.repfilter(c,e:GetHandlerPlayer())
end
function c50218645.repop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end
function c50218645.rfilter(c,e)
    return (not e or c:IsRelateToEffect(e)) and c:IsAbleToRemove()
end
function c50218645.retg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(c50218645.rfilter,1,nil,nil) and not eg:IsContains(e:GetHandler()) end
    local g=eg:Filter(c50218645.rfilter,nil,nil)
    Duel.SetTargetCard(eg)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c50218645.reop(e,tp,eg,ep,ev,re,r,rp)
    local g=eg:Filter(c50218645.rfilter,nil,e)
    if g:GetCount()>0 then
        Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
    end
end
function c50218645.pencon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return (c:IsReason(REASON_BATTLE) or (c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT)))
        and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c50218645.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c50218645.penop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end