--守护的战女神 雅典娜
function c47514896.initial_effect(c)
    aux.AddXyzProcedureLevelFree(c,c47514896.mfilter,nil,2,2)
    c:EnableReviveLimit() 
    --pendulum summon
    aux.EnablePendulumAttribute(c,false)
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47514896.psplimit)
    c:RegisterEffect(e1) 
    --pendulum set
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47514896,0))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1,47514896)
    e2:SetCondition(c47514896.pencon)
    e2:SetTarget(c47514896.pentg)
    e2:SetOperation(c47514896.penop)
    c:RegisterEffect(e2)  
    --serch
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47514896,1))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,47514897)
    e3:SetCondition(c47514896.thcon)
    e3:SetTarget(c47514896.thtg)
    e3:SetOperation(c47514896.thop)
    c:RegisterEffect(e3)
    --act limit
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_CHAINING)
    e4:SetRange(LOCATION_MZONE)
    e4:SetOperation(c47514896.chainop)
    c:RegisterEffect(e4)  
    --apply effect
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(47514896,2))
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetCost(c47514896.effcost)
    e5:SetTarget(c47514896.efftg)
    e5:SetOperation(c47514896.effop)
    c:RegisterEffect(e5)
end
c47514896.pendulum_level=8
function c47514896.mfilter(c)
    return c:IsSetCard(0x5da)
end
function c47514896.pefilter(c)
    return c:IsRace(RACE_FAIRY) or c:IsSetCard(0x5da) or c:IsAttribute(ATTRIBUTE_FIRE)
end
function c47514896.psplimit(e,c,tp,sumtp,sumpos)
    return not c47514896.pefilter(c) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47514896.cfilter(c)
    return c:IsType(TYPE_PENDULUM)
end
function c47514896.pencon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c47514896.cfilter,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function c47514896.penfilter(c)
    return c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c47514896.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    local sc=Duel.GetFirstMatchingCard(nil,tp,LOCATION_PZONE,0,e:GetHandler())
    if chk==0 then return e:GetHandler():IsDestructable()
        and Duel.IsExistingMatchingCard(c47514896.penfilter,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.SetTargetCard(sc)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sc,1,0,0)
end
function c47514896.penop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
        local g=Duel.SelectMatchingCard(tp,c47514896.penfilter,tp,LOCATION_EXTRA,0,1,1,nil)
        local tc=g:GetFirst()
        if tc then
            Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        end
    end
end
function c47514896.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c47514896.thfilter(c)
    return (c:IsSetCard(0x5da) or c:IsSetCard(0x5de) or c:IsSetCard(0x5d0)) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand() and c:IsFaceup()
end
function c47514896.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47514896.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c47514896.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c47514896.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c47514896.chainop(e,tp,eg,ep,ev,re,r,rp)
    if re:GetHandler():IsType(TYPE_PENDULUM) and re:IsActiveType(TYPE_SPELL) and ep==tp then
        Duel.SetChainLimit(c47514896.chainlm)
    end
end
function c47514896.chainlm(e,rp,tp)
    return tp==rp
end
function c47514896.effcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c47514896.efffilter(c,e,tp,eg,ep,ev,re,r,rp)
    local m=_G["c"..c:GetCode()]
    local te=m.ss_effect
    if not te then return false end
    local tg=te:GetTarget()
    return c:IsSetCard(0x5da) and c:IsType(TYPE_PENDULUM) and (not tg or tg and tg(e,tp,eg,ep,ev,re,r,rp,0))
end
function c47514896.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED) and chkc:IsControler(tp) and c47514896.efffilter(chkc,e,tp,eg,ep,ev,re,r,rp) end
    if chk==0 then return Duel.IsExistingTarget(c47514896.efffilter,tp,LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectTarget(tp,c47514896.efffilter,tp,LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
    local m=_G["c"..g:GetFirst():GetCode()]
    local te=m.ss_effect
    local tg=te:GetTarget()
    if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
end
function c47514896.effop(e,tp,eg,ep,ev,re,r,rp,chk)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.ConfirmCards(1-tp,tc)
        local m=_G["c"..tc:GetCode()]
        local te=m.ss_effect
        if not te then return end
        local op=te:GetOperation()
        if op then op(e,tp,eg,ep,ev,re,r,rp) end 
    end  
end