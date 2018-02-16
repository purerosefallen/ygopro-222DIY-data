--六曜的新源丘儿
function c12001025.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xfb0),4,2)
	c:EnableReviveLimit()
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12001025,0))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCost(c12001025.cost)
	e1:SetTarget(c12001025.distg3)
	e1:SetOperation(c12001025.disop)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c12001025.desreptg)
	e4:SetOperation(c12001025.desrepop)
	c:RegisterEffect(e4)
end
function c12001025.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c12001025.filter3(c)
	return c:IsFaceup() and not c:IsCode(12001025)
end
function c12001025.distg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c12001025.filter3,1,nil) end
	local g=eg:Filter(c12001025.filter3,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
end
function c12001025.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsType(TYPE_EFFECT) then
		c:SetCardTarget(tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetCondition(c12001025.rcon)
		tc:RegisterEffect(e1,true)
	end
end
function c12001025.rcon(e)
	return e:GetOwner():IsHasCardTarget(e:GetHandler())
end
function c12001025.repfilter(c)
	return c:GetSequence()<5 and ( c:IsType(TYPE_CONTINUOUS) or c:IsFacedown() ) and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function c12001025.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField() and c:IsFaceup()
		and Duel.IsExistingMatchingCard(c12001025.repfilter,tp,LOCATION_SZONE,0,1,c) end
	if Duel.SelectYesNo(tp,aux.Stringid(12001025,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,c12001025.repfilter,tp,LOCATION_SZONE,0,1,1,c)
		e:SetLabelObject(g:GetFirst())
		Duel.HintSelection(g)
		g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function c12001025.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
end
