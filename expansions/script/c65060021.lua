--FOLKS OF DRAEM
function c65060021.initial_effect(c)
	c:SetUniqueOnField(LOCATION_SZONE,0,65060021)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c65060021.target)
	e1:SetOperation(c65060021.activate)
	c:RegisterEffect(e1)
	--summon success
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetTarget(c65060021.sumfilter)
	e4:SetOperation(c65060021.sumsuc)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	c:RegisterEffect(e5)
	--Pos Change
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_SET_POSITION)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTarget(c65060021.postar)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetValue(POS_FACEUP_DEFENSE)
	c:RegisterEffect(e6)
end
function c65060021.sumfilter(e,c)
	return c:IsSetCard(0x6da4) and c:GetSummonPlayer()==e:GetHandlerPlayer()
end
function c65060021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c65060021.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		local c=e:GetHandler()
		local g=Duel.GetOperatedGroup()
		local tc=g:GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		Duel.BreakEffect()
		if not tc:IsSetCard(0x6da4) then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
		Duel.ShuffleHand(tp)
	end
end
function c65060021.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
function c65060021.postar(e,c)
	return c:IsPosition(POS_FACEUP)
end