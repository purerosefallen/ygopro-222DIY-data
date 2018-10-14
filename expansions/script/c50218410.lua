--Black Panther the Avenger of Freedom
function c50218410.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,nil,2,2,c50218410.lcheck)
    c:EnableReviveLimit()
    --todeck
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TODECK)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,50218410)
    e1:SetCondition(c50218410.tdcon)
    e1:SetTarget(c50218410.tdtg)
    e1:SetOperation(c50218410.tdop)
    c:RegisterEffect(e1)
    --cannot release
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_UNRELEASABLE_SUM)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e2:SetCondition(c50218410.rcon)
    e2:SetTarget(c50218410.rtg)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    local e22=e2:Clone()
    e22:SetCode(EFFECT_UNRELEASABLE_NONSUM)
    c:RegisterEffect(e22)
    --draw
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_LEAVE_FIELD)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,50218411)
    e3:SetCondition(c50218410.dcon)
    e3:SetTarget(c50218410.dtg)
    e3:SetOperation(c50218410.dop)
    c:RegisterEffect(e3)
end
function c50218410.lcheck(g)
    return g:GetClassCount(Card.GetLinkRace)==g:GetCount()
end
function c50218410.tdcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetMutualLinkedGroupCount()>=2
end
function c50218410.tdfilter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeck()
end
function c50218410.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and c50218410.tdfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c50218410.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,c50218410.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c50218410.tdop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
    end
end
function c50218410.rcon(e)
    return e:GetHandler():GetMutualLinkedGroupCount()>0
end
function c50218410.rtg(e,c)
    local g=e:GetHandler():GetMutualLinkedGroup()
    return c==e:GetHandler() or g:IsContains(c)
end
function c50218410.dcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return (c:IsReason(REASON_BATTLE) or (c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT)))
        and c:IsPreviousPosition(POS_FACEUP)
end
function c50218410.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c50218410.dop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end