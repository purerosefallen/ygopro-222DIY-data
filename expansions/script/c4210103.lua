--双剑乱舞的莉昂
function c4210103.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,function(c)return c:IsFaceup()and c:IsRace(RACE_BEAST) and c:IsType(TYPE_MONSTER) end,4,2,function(c)return c:IsFaceup()and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsType(TYPE_MONSTER) and c:GetOverlayCount()==2 and not c:IsCode(4210103) end,aux.Stringid(4210103,0))
	c:EnableReviveLimit()	
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c4210103.reptg)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4210103,2))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,4210103)
	e2:SetCost(c4210103.spcost)
	e2:SetTarget(c4210103.sptg)
	e2:SetOperation(c4210103.spop)
	c:RegisterEffect(e2)
end
function c4210103.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end
function c4210103.spfilter(c,e,tp)
	return c:IsSetCard(0xa2c) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c4210103.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c4210103.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c4210103.spop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		local tc=Duel.GetOperatedGroup():GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		Duel.BreakEffect()
		if tc:IsType(TYPE_MONSTER) and tc:IsSetCard(0xa2c) then
			if Duel.IsExistingTarget(function(c)return c:IsFacedown() and c:IsType(TYPE_SPELL+TYPE_TRAP) end,tp,0,LOCATION_ONFIELD,1,nil)then
				if Duel.SelectYesNo(tp,aux.Stringid(4210103,1)) then
					local tc=Duel.SelectMatchingCard(tp,function(c)return c:IsFacedown() and c:IsType(TYPE_SPELL+TYPE_TRAP) end,tp,0,LOCATION_ONFIELD,1,1,nil)
					if tc:GetCount()>0 then
						Duel.Destroy(tc,REASON_EFFECT)
					end
				end
			end
		end
		Duel.ShuffleHand(tp)
	end
end