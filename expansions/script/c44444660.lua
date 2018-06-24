--幽水❀森狐
function c44444660.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),4,2)
	c:EnableReviveLimit()
	--xyz
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetDescription(aux.Stringid(44444660,0))
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c44444660.xyzcon)
	e1:SetOperation(c44444660.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)

	--defense attack
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_DEFENSE_ATTACK)
	e11:SetValue(1)
	c:RegisterEffect(e11)
	--position
	local e21=Effect.CreateEffect(c)
	e21:SetDescription(aux.Stringid(44444660,2))
	e21:SetCategory(CATEGORY_POSITION)
	e21:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e21:SetType(EFFECT_TYPE_QUICK_O)
	e21:SetCode(EVENT_FREE_CHAIN)
	e21:SetRange(LOCATION_MZONE)
	e21:SetHintTiming(TIMING_BATTLE_PHASE,0x1c0+TIMING_BATTLE_PHASE)
	e21:SetCountLimit(1)
	e21:SetCost(c44444660.cost)
	e21:SetTarget(c44444660.postg)
	e21:SetOperation(c44444660.posop)
	c:RegisterEffect(e21)
end
function c44444660.xyzfilter1(c)
	return c:IsCode(44444000)
end
function c44444660.xyzfilter2(c)
	return c:IsDefensePos() and c:IsFaceup() and not c:IsType(TYPE_TOKEN)
end
function c44444660.xyzfilter3(c)
	return c:IsDefensePos() and c:IsFaceup() and not c:IsType(TYPE_TOKEN) and c:IsType(TYPE_XYZ)
end
function c44444660.xyzcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,0x4)<=0 then return false end
	return Duel.IsExistingMatchingCard(c44444660.xyzfilter1,tp,LOCATION_ONFIELD,0,1,nil) 
	and Duel.IsExistingMatchingCard(c44444660.xyzfilter2,tp,0,LOCATION_MZONE,1,nil)
end
function c44444660.xyzop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local g1=Duel.SelectMatchingCard(tp,c44444660.xyzfilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c44444660.xyzfilter2,tp,0,LOCATION_MZONE,1,1,nil)
	g1:Merge(g2)
		local tc=g1:GetFirst()
	    if tc and tc:IsType(TYPE_XYZ) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
            end
		end
    c:SetMaterial(g1)
	Duel.Overlay(c,g1)
		
	
end

function c44444660.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c44444660.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c44444660.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c44444660.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c44444660.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c44444660.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c44444660.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
		local e1=Effect.CreateEffect(e:GetHandler())
	    e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end