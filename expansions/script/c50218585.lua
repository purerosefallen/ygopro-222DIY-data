--伏龙之源
function c50218585.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,50218585+EFFECT_COUNT_CODE_OATH)
    e1:SetCost(c50218585.cost)
    e1:SetTarget(c50218585.target)
    e1:SetOperation(c50218585.activate)
    c:RegisterEffect(e1)
    --remove overlay replace
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(50218585,0))
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCondition(c50218585.rcon)
    e2:SetOperation(c50218585.rop)
    c:RegisterEffect(e2)
end
function c50218585.filter(c)
    return c:IsSetCard(0xcb5) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c50218585.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c50218585.filter,tp,LOCATION_HAND,0,1,nil) end
    Duel.DiscardHand(tp,c50218585.filter,1,1,REASON_COST+REASON_DISCARD)
end
function c50218585.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(2)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c50218585.activate(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end
function c50218585.rcon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_COST)~=0 and re:IsHasType(0x7e0)
        and re:IsActiveType(TYPE_XYZ) and re:GetHandler():IsSetCard(0xcb5)
        and e:GetHandler():IsAbleToRemoveAsCost()
        and ep==e:GetOwnerPlayer() and ev==1
end
function c50218585.rop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end