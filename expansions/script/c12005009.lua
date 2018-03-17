--六曜 与新源丘儿的接触
function c12005009.initial_effect(c)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12005009,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetCondition(c12005009.condition)
	e1:SetTarget(c12005009.target)
	e1:SetOperation(c12005009.operation)
	c:RegisterEffect(e1)
end
function c12005009.cfilter(c,tp)
	return c:GetSummonPlayer()==1-tp and not c:IsPreviousLocation(LOCATION_HAND)
end
function c12005009.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c12005009.cfilter,1,nil,tp)
end
function c12005009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c12005009.filter1(c)
	return c:IsSetCard(0xfbb)
end
function c12005009.sfilter(c,e,tp)
	return c:IsCode(12005013) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12005009.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if not tc:IsDisabled() then
		 Duel.NegateSummon(eg) 
			if Duel.IsExistingMatchingCard(c12005009.filter1,tp,LOCATION_HAND,0,1,nil) then
			local g=Duel.SelectMatchingCard(tp,c12005009.filter1,tp,LOCATION_HAND,0,1,1,nil)
			local sc=Duel.GetFirstMatchingCard(c12005009.sfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
			if sc and Duel.GetLocationCountFromEx(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(12005009,1)) then
				Duel.BreakEffect()
				Duel.SendtoGrave(g,REASON_EFFECT)
				Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end