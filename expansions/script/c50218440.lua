--Captain America the Avenger of Justice
function c50218440.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,nil,2,3,c50218440.lcheck)
    c:EnableReviveLimit()
    --disable spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EVENT_SPSUMMON)
    e1:SetCountLimit(1,50218440)
    e1:SetCondition(c50218440.negcon)
    e1:SetTarget(c50218440.negtg)
    e1:SetOperation(c50218440.negop)
    c:RegisterEffect(e1)
    --indes
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e2:SetCondition(c50218440.incon)
    e2:SetTarget(c50218440.intg)
    c:RegisterEffect(e2)
    --draw
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_LEAVE_FIELD)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,50218441)
    e3:SetCondition(c50218440.dcon)
    e3:SetTarget(c50218440.dtg)
    e3:SetOperation(c50218440.dop)
    c:RegisterEffect(e3)
end
function c50218440.lcheck(g)
    return g:GetClassCount(Card.GetLinkRace)==g:GetCount()
end
function c50218440.negcon(e,tp,eg,ep,ev,re,r,rp)
    return tp~=ep and Duel.GetCurrentChain()==0 and e:GetHandler():GetMutualLinkedGroupCount()>=3
end
function c50218440.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c50218440.negop(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateSummon(eg)
    Duel.Destroy(eg,REASON_EFFECT)
end
function c50218440.incon(e)
    return e:GetHandler():GetMutualLinkedGroupCount()>0
end
function c50218440.intg(e,c)
    local g=e:GetHandler():GetMutualLinkedGroup()
    return c==e:GetHandler() or g:IsContains(c)
end
function c50218440.dcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return (c:IsReason(REASON_BATTLE) or (c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT)))
        and c:IsPreviousPosition(POS_FACEUP)
end
function c50218440.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c50218440.dop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end