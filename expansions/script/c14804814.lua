--IDOL 发卡
function c14804814.initial_effect(c)
	--link summon
	c:SetUniqueOnField(1,1,aux.FilterBoolFunction(Card.IsCode,14804814),LOCATION_MZONE)
	aux.AddLinkProcedure(c,c14804816.matfilter,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c14804814.atktg)
	e1:SetValue(c14804814.atkval)
	c:RegisterEffect(e1)
	--avoid damage.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetValue(c14804814.damval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(14804814,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c14804814.thtg)
	e4:SetOperation(c14804814.thop)
	c:RegisterEffect(e4)
	--act limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(1,1)
	e5:SetCondition(c14804814.limcon)
	e5:SetValue(c14804814.limval)
	c:RegisterEffect(e5)
end
function c14804816.matfilter(c)
	return c:IsSetCard(0x4848) and c:IsLinkType(TYPE_LINK)
end
function c14804814.atktg(e,c)
	return not c:IsSetCard(0x4848)
end
function c14804814.vfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x4848)
end
function c14804814.atkval(e,c)
	return Duel.GetMatchingGroupCount(c14804814.vfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*-500
end
function c14804814.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_BATTLE)~=0 then return 0 end
	return val
end

function c14804814.thfilter(c)
	return c:IsSetCard(0x4848) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c14804814.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp,1) and Duel.IsExistingMatchingCard(c14804814.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function c14804814.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c14804814.thfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.BreakEffect()
		Duel.Draw(1-tp,1,REASON_EFFECT)
	end
end

function c14804814.cfilter1(c)
	return c:IsSetCard(0x4848)
end
function c14804814.limcon(e)
	return Duel.IsExistingMatchingCard(c14804814.cfilter1,tp,LOCATION_MZONE,0,4,nil)
end
function c14804814.limval(e,re,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and not rc:IsSetCard(0x4848) and not rc:IsImmuneToEffect(e)
end