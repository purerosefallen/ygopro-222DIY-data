--伏龙之援
function c50218590.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCategory(CATEGORY_RECOVER)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,50218590+EFFECT_COUNT_CODE_OATH)
    e1:SetCost(c50218590.cost)
    e1:SetTarget(c50218590.tg)
    e1:SetOperation(c50218590.op)
    c:RegisterEffect(e1)
    --remove overlay replace
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(50218590,0))
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCondition(c50218590.rcon)
    e2:SetOperation(c50218590.rop)
    c:RegisterEffect(e2)
end
function c50218590.filter(c)
    return c:IsSetCard(0xcb5) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c50218590.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c50218590.filter,tp,LOCATION_HAND,0,1,nil) end
    Duel.DiscardHand(tp,c50218590.filter,1,1,REASON_COST+REASON_DISCARD)
end
function c50218590.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1000)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c50218590.op(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Recover(p,d,REASON_EFFECT)
end
function c50218590.rcon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_COST)~=0 and re:IsHasType(0x7e0)
        and re:IsActiveType(TYPE_XYZ) and re:GetHandler():IsSetCard(0xcb5)
        and e:GetHandler():IsAbleToRemoveAsCost()
        and ep==e:GetOwnerPlayer() and ev==1
end
function c50218590.rop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
