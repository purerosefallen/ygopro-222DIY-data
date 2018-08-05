function c12011029.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,
	function(c) return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_PENDULUM) end,3,3,
	function(c) return c:IsFaceup() and c:IsRank(3) and c:IsAttribute(ATTRIBUTE_DARK) end,aux.Stringid(12011019,0),3,
	function(e,tp,chk) if chk==0 then return Duel.IsExistingMatchingCard(c12011029.rumfilter,tp,LOCATION_HAND,0,1,nil) end Duel.DiscardHand(tp,c12011029.rumfilter,1,1,REASON_COST+REASON_DISCARD) end)
	c:EnableReviveLimit()
	iFunc(c).c("RegisterEffect",iFunc(c)
		.e("SetType",EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		.e("SetProperty",EFFECT_FLAG_DELAY)
		.e("SetCode",EVENT_SPSUMMON_SUCCESS)
		.e("SetCondition",function(e,tp,eg,ep,ev,re,r,rp)
			return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) end)
		.e("SetTarget",function (e,tp,eg,ep,ev,re,r,rp,chk) if chk==0 then 
			return Duel.IsExistingMatchingCard(c12011029.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end end)		
		.e("SetOperation",function(e,tp,eg,ep,ev,re,r,rp)
			local g=Duel.SelectMatchingCard(tp,c12011029.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)			
			if g:GetCount()>0 then Duel.Overlay(e:GetHandler(),g) end
		end)
	.Return()).c("RegisterEffect",iFunc(c)
		.e("SetType",EFFECT_TYPE_IGNITION)
		.e("SetCategory",CATEGORY_TOHAND)
		.e("SetRange",LOCATION_MZONE)
		.e("SetCountLimit",1)
		.e("SetCost",function(e,tp,eg,ep,ev,re,r,rp,chk)if chk==0 then 
			return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
			e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST) end)
		.e("SetTarget",function (e,tp,eg,ep,ev,re,r,rp,chk) if chk==0 then 
			return Duel.IsExistingMatchingCard(c12011029.mcfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end end)
		.e("SetOperation",function (e,tp,eg,ep,ev,re,r,rp)
			local g=Duel.SelectMatchingCard(tp,c12011029.mcfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
			if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then Duel.ConfirmCards(1-tp,g)
				if Duel.SelectYesNo(tp,504) then 
					Duel.SendtoGrave(Duel.SelectMatchingCard(tp,function(c) return c:GetLevel()==3 and c:IsAbleToGrave() and c12011029.cfilter(c) end,tp,LOCATION_DECK,0,1,1,nil),REASON_EFFECT)
				end			
			end end)
	.Return()).c("RegisterEffect",iFunc(c)
		.e("SetCategory",CATEGORY_SPECIAL_SUMMON)
		.e("SetType",EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		.e("SetRange",LOCATION_MZONE)
		.e("SetCode",EVENT_DESTROYED)		
		.e("SetProperty",EFFECT_FLAG_DELAY)
		.e("SetCost",function(e,tp,eg,ep,ev,re,r,rp,chk)if chk==0 then 
			return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
			e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST) end)
		.e("SetTarget",function(e,tp,eg,ep,ev,re,r,rp,chk) local tc=eg:GetFirst()
			if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
				and tc:IsLocation(LOCATION_GRAVE) and tc:IsReason(REASON_EFFECT)
				and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp) end
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,eg,1,0,0) end)
		.e("SetOperation",function(e,tp,eg,ep,ev,re,r,rp) Duel.SpecialSummon(eg:Select(tp,1,1,nil),0,tp,tp,false,false,POS_FACEUP) end)
	.Return())
end
function c12011029.rumfilter(c)
	return c:IsSetCard(0x95) and c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function c12011029.cfilter(c) 
	return c:IsRace(RACE_SPELLCASTER) and  c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_MONSTER) 
end
function c12011029.mcfilter(c) 
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_SPELLCASTER) and  c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_MONSTER) 
		and (c:IsLocation(LOCATION_GRAVE) or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()))
end
function iFunc(c,x)
	local __this = (aux.GetValueType(c) == "Card" and {(x == nil and {Effect.CreateEffect(c)} or {x})[1]} or {x})[1] 
	local fe = function(name,...) (type(__this[name])=="function" and {__this[name]} or {""})[1](__this,...) return iFunc(c,__this) end
	local fc = function(name,...) this = (type(c[name])=="function" and {c[name]} or {""})[1](c,...) return iFunc(c,c) end	
	local func ={e = fe,c = fc,g = fc,v = function() return this end,Return = function() return __this:Clone() end}
	return func
end
