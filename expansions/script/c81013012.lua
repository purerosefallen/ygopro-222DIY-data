--琉璃色·金鱼·花菖蒲
function c81013012.initial_effect(c)
	aux.AddRitualProcGreaterCode(c,81013011)
	--token
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,81013012)
	e3:SetCondition(aux.exccon)
	e3:SetCost(c81013012.spcost)
	e3:SetTarget(c81013012.sptg)
	e3:SetOperation(c81013012.spop)
	c:RegisterEffect(e3)
end
function c81013012.costfilter(c)
	return c:IsType(TYPE_FUSION) and c:IsFaceup() and c:IsAbleToExtraAsCost()
end
function c81013012.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c81013012.costfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c81013012.costfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c81013012.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,81013013,0,0x4011,2100,2850,7,RACE_ZOMBIE,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c81013012.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,81013013,0,0x4011,2100,2850,7,RACE_ZOMBIE,ATTRIBUTE_DARK) then
		local token=Duel.CreateToken(tp,81013013)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
