--炼金工作室-亚兰德的炼金术师
function c4212304.initial_effect(c)
	c:SetUniqueOnField(1,0,4212304)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetOperation(c4212304.mvop)
	c:RegisterEffect(e2)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4212304,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c4212304.condition)
	e1:SetTarget(c4212304.thtg)
	e1:SetOperation(c4212304.thop)
	c:RegisterEffect(e1)
end
function c4212304.mvfilter1(c)
	return c:IsFaceup()
end
function c4212304.mvfilter2(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xa25) and c:GetSequence()<5
		and Duel.IsExistingMatchingCard(c4212304.mvfilter3,tp,LOCATION_MZONE,0,1,c)
end
function c4212304.mvfilter3(c)
	return c:IsFaceup() and c:IsSetCard(0xa25) and c:GetSequence()<5
end
function c4212304.mvop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c4212304.mvfilter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 then
		if Duel.SelectEffectYesNo(tp,e:GetHandler(),95) then
			if not e:GetHandler():IsRelateToEffect(e) then return end
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(4212304,2))
			local g=Duel.SelectMatchingCard(tp,c4212304.mvfilter1,tp,LOCATION_MZONE,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
				local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
				local nseq=math.log(s,2)
				Duel.MoveSequence(g:GetFirst(),nseq)
			end
		end
	end
end
function c4212304.mfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa25) and c:IsType(TYPE_SPELL)
end
function c4212304.mfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL)
end
function c4212304.thfilter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c:GetColumnGroup():Filter(c4212304.mfilter,nil,e):GetCount()>0
end
function c4212304.thfilter2(c,g)
	return g:IsContains(c)
end
function c4212304.condition(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetMatchingGroupCount(c4212306.mfilter2,tp,LOCATION_SZONE,0,nil)>=3 and Duel.GetTurnPlayer()~=tp) or Duel.GetTurnPlayer()==tp
end
function c4212304.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4212304.thfilter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c4212304.thfilter,tp,LOCATION_MZONE,0,1,1,nil)
	e:SetLabel(g:GetFirst():GetSequence())
	local sg = g:GetFirst():GetColumnGroup()
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c4212304.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() then
		local sg = Duel.GetMatchingGroup(function(c,zone) 
			return c:GetSequence() == zone 
				or (math.ceil(c:GetSequence())==5 and zone==1 ) 
				or (math.ceil(c:GetSequence())==6 and zone==3 ) 
			end,tp,LOCATION_ONFIELD,0,nil,math.ceil(e:GetLabel()))
		local sg2 = Duel.GetMatchingGroup(function(c,zone) 
			return c:GetSequence() == 4-zone 
				or (math.ceil(c:GetSequence())==6 and zone==1 ) 
				or (math.ceil(c:GetSequence())==5 and zone==3 ) 
			end,tp,0,LOCATION_ONFIELD,nil,math.ceil(e:GetLabel()))
		sg:Merge(sg2)
		if sg:GetCount()>0 then		
			Duel.Destroy(sg,REASON_EFFECT)
		end
	end
end