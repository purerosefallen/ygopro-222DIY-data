--灵刻使 领袖
local m=10904006
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.EnablePendulumAttribute(c)
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e0:SetRange(LOCATION_HAND+LOCATION_EXTRA)
    e0:SetCondition(cm.hspcon)
    e0:SetOperation(cm.hspop)
    c:RegisterEffect(e0)  
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(29432356,0))
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_PZONE)
    e1:SetHintTiming(0,0x1c0)
    e1:SetCountLimit(1,m)
    e1:SetTarget(cm.sctg)
    e1:SetOperation(cm.scop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetTargetRange(1,0)
    e2:SetTarget(cm.splimit)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CHANGE_LSCALE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(LOCATION_PZONE,LOCATION_PZONE)
    e3:SetValue(0)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_CHANGE_RSCALE)
    c:RegisterEffect(e4)
    local e6=e3:Clone()
    e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e6:SetValue(aux.tgoval)
    c:RegisterEffect(e6)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetCode(EVENT_CHAINING)
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e5:SetCountLimit(1)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCondition(cm.discon)
    e5:SetTarget(cm.tg2)
    e5:SetCost(cm.discost)
    e5:SetOperation(cm.op)
    c:RegisterEffect(e5)
    local e10=Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_SINGLE)
    e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e10:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e10)    
end
function cm.mzfilter(c,tp)
    return c:IsControler(tp) and c:GetSequence()<5
end
function cm.hspcon(e,c)
    if c==nil then return true end
    local tp=e:GetHandler():GetControler()
    local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
    local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
    if not tc1 or not tc2 then return false end
    local rg=Duel.GetReleaseGroup(tp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local ct=-ft+1
    return ft>-3 and rg:GetCount()>2 and (ft>0 or rg:IsExists(cm.mzfilter,ct,nil,tp)) and tc1:GetLeftScale()==tc2:GetRightScale()
end
function cm.hspop(e,tp,eg,ep,ev,re,r,rp,c)
    local rg=Duel.GetReleaseGroup(tp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local g=nil
    if ft>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        g=rg:Select(tp,3,3,nil)
    elseif ft>-2 then
        local ct=-ft+1
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        g=rg:FilterSelect(tp,cm.mzfilter,ct,ct,nil,tp)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        local g2=rg:Select(tp,3-ct,3-ct,g)
        g:Merge(g2)
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        g=rg:FilterSelect(tp,cm.mzfilter,3,3,nil,tp)
    end
    Duel.Release(g,REASON_COST)
end
function cm.scfilter(c,pc)
    return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x237) and not c:IsForbidden()
        and c:GetLeftScale()~=pc:GetLeftScale()
end
function cm.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.scfilter,tp,LOCATION_DECK,0,1,nil,e:GetHandler()) end
end
function cm.scop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(29432356,1))
    local g=Duel.SelectMatchingCard(tp,cm.scfilter,tp,LOCATION_DECK,0,1,1,nil,c)
    local tc=g:GetFirst()
    if tc and Duel.SendtoExtraP(tc,tp,REASON_EFFECT)>0 then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_LSCALE)
        e1:SetValue(tc:GetLeftScale())
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_CHANGE_RSCALE)
        e2:SetValue(tc:GetRightScale())
        c:RegisterEffect(e2)
    end
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp)
    return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.rmfilter(c)
    return c:IsType(TYPE_PENDULUM) and c:IsAbleToRemoveAsCost()
end
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.rmfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,cm.rmfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.tfilter2(c)
    return c:IsFaceup()
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_ONFIELD) end
    if chk==0 then return Duel.IsExistingTarget(cm.tfilter2,tp,LOCATION_ONFIELD,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
    local g=Duel.SelectTarget(tp,cm.tfilter2,tp,LOCATION_ONFIELD,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,LOCATION_ONFIELD)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        local e2_1=Effect.CreateEffect(c)
        e2_1:SetType(EFFECT_TYPE_SINGLE)
        e2_1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e2_1:SetRange(LOCATION_ONFIELD)
        e2_1:SetCode(EFFECT_IMMUNE_EFFECT)
        e2_1:SetValue(cm.val2_1)
        e2_1:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
        tc:RegisterEffect(e2_1)
    end
end
function cm.val2_1(e,re)
    return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
