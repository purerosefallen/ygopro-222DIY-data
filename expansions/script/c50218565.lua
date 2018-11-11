--真伏龙王-神辉
function c50218565.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,nil,8,3)
    c:EnableReviveLimit()
    --atkdown
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(50218565,0))
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCost(c50218565.atkcost)
    e1:SetCondition(c50218565.atkcon)
    e1:SetTarget(c50218565.atktg)
    e1:SetOperation(c50218565.atkop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    --attach
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(50218565,1))
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCode(EVENT_PHASE+PHASE_END)
    e3:SetCountLimit(1)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c50218565.mtcon)
    e3:SetTarget(c50218565.mttg)
    e3:SetOperation(c50218565.mtop)
    c:RegisterEffect(e3)
    --destroy replace
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EFFECT_DESTROY_REPLACE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTarget(c50218565.reptg)
    c:RegisterEffect(e4)
end
function c50218565.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c50218565.atkfilter(c,e,tp)
    return c:IsControler(tp) and c:IsPosition(POS_FACEUP) and (not e or c:IsRelateToEffect(e))
end
function c50218565.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c50218565.atkfilter,1,nil,nil,1-tp)
end
function c50218565.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetCard(eg)
end
function c50218565.atkop(e,tp,eg,ep,ev,re,r,rp)
    local g=eg:Filter(c50218565.atkfilter,nil,e,1-tp)
    local dg=Group.CreateGroup()
    local c=e:GetHandler()
    local tc=g:GetFirst()
    while tc do
        local preatk=tc:GetAttack()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(-2000)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
        if preatk~=0 and tc:IsAttack(0) then dg:AddCard(tc) end
        tc=g:GetNext()
    end
    Duel.Destroy(dg,REASON_EFFECT)
end
function c50218565.mtcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c50218565.mtfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xcb5)
end
function c50218565.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c50218565.mtfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c50218565.mtfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local sg=Duel.SelectTarget(tp,c50218565.mtfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,sg,1,0,0)
end
function c50218565.mtop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsFaceup() and c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
        Duel.Overlay(c,Group.FromCards(tc))
    end
end
function c50218565.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
    if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
        c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
        return true
    else return false end
end