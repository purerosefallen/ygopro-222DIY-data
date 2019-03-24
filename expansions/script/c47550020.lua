--荣光的圣骑士 夏露罗蒂
function c47550020.initial_effect(c)
	c:EnableCounterPermit(0x55d0)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_PENDULUM),7,2,nil,nil,99)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)	  
	--quick pendulum
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(47550020,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,47550020+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c47550020.pspcon)
	e1:SetOperation(c47550020.pspop)
	c:RegisterEffect(e1)   
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c47550020.indcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	--Add counter
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(9634146,0))
	e5:SetCategory(CATEGORY_COUNTER)
	e5:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c47550020.cttg)
	e5:SetOperation(c47550020.ctop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_PHASE+PHASE_END)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE) 
	e7:SetCode(EFFECT_UPDATE_ATTACK)
	e7:SetRange(LOCATION_MZONE) 
	e7:SetValue(c47550020.attackup)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_EXTRA_ATTACK)
	e8:SetValue(1)
	e8:SetCondition(c47550020.dacon)
	c:RegisterEffect(e8)
	--negate activate
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(47550020,0))
	e9:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY+CATEGORY_REMOVE)
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCountLimit(1)
	e9:SetCode(EVENT_CHAINING)
	e9:SetCondition(c47550020.negcon)
	e9:SetCost(c47550020.negcost)
	e9:SetTarget(c47550020.negtg)
	e9:SetOperation(c47550020.negop)
	c:RegisterEffect(e9)
	--atk bgm
	local e10=Effect.CreateEffect(c)
	e10:SetCategory(CATEGORY_ATKCHANGE)
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e10:SetCode(EVENT_ATTACK_ANNOUNCE)
	e10:SetOperation(c47550020.atksuc)
	c:RegisterEffect(e10)
end
function c47550020.pspcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
				if c==nil then return true end
				local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
				if rpz==nil or c==rpz then return false end
				local lscale=c:GetLeftScale()
				local rscale=rpz:GetRightScale()
				if lscale>rscale then lscale,rscale=rscale,lscale end
				local loc=0
				if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
				if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
				if loc==0 then return false end
				local g=nil
				if og then
					g=og:Filter(Card.IsLocation,nil,loc)
				else
					g=Duel.GetFieldGroup(tp,loc,0)
				end
				local ph=Duel.GetCurrentPhase()
				return g:IsExists(aux.PConditionFilter,1,nil,e,tp,lscale,rscale,eset) and Duel.GetTurnPlayer()~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c47550020.pspop(e,tp,eg,ep,ev,re,r,rp,sg,og)
	local c=e:GetHandler()
				local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
				local lscale=c:GetLeftScale()
				local rscale=rpz:GetRightScale()
				if lscale>rscale then lscale,rscale=rscale,lscale end
				local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
				local tg=nil
				local loc=0
				local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
				local ft2=Duel.GetLocationCountFromEx(tp)
				local ft=Duel.GetUsableMZoneCount(tp)
				local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
				if ect and ect<ft2 then ft2=ect end
				if Duel.IsPlayerAffectedByEffect(tp,59822133) then
					if ft1>0 then ft1=1 end
					if ft2>0 then ft2=1 end
					ft=1
				end
				if ft1>0 then loc=loc|LOCATION_HAND end
				if ft2>0 then loc=loc|LOCATION_EXTRA end
				if og then
					tg=og:Filter(Card.IsLocation,nil,loc):Filter(aux.PConditionFilter,nil,e,tp,lscale,rscale,eset)
				else
					tg=Duel.GetMatchingGroup(aux.PConditionFilter,tp,loc,0,nil,e,tp,lscale,rscale,eset)
				end
				local ce=nil
				local b1=PENDULUM_CHECKLIST&(0x1<<tp)==0
				local b2=#eset>0
				if b1 and b2 then
					local options={1163}
					for _,te in ipairs(eset) do
						table.insert(options,te:GetDescription())
					end
					local op=Duel.SelectOption(tp,table.unpack(options))
					if op>0 then
						ce=eset[op]
					end
				elseif b2 and not b1 then
					local options={}
					for _,te in ipairs(eset) do
						table.insert(options,te:GetDescription())
					end
					local op=Duel.SelectOption(tp,table.unpack(options))
					ce=eset[op+1]
				end
				if ce then
					tg=tg:Filter(aux.PConditionExtraFilterSpecific,nil,e,tp,lscale,rscale,ce)
				end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=tg:SelectSubGroup(tp,aux.PendOperationCheck,true,1,#tg,ft1,ft2,ft)
				if not g then return end
				if ce then
					Duel.Hint(HINT_CARD,0,ce:GetOwner():GetOriginalCode())
					ce:Reset()
				end
				Duel.HintSelection(Group.FromCards(c))
				Duel.HintSelection(Group.FromCards(rpz))
	for tc in aux.Next(g) do
		local bool=aux.PendulumSummonableBool(tc)
		Duel.SpecialSummonStep(tc,SUMMON_TYPE_PENDULUM,tp,tp,bool,bool,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
	for tc in aux.Next(g) do tc:CompleteProcedure() end
end
function c47550020.indcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c47550020.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(aux.TRUE)
end
function c47550020.ctop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x55d0,1)
		Duel.Hint(HINT_SOUND,0,aux.Stringid(47550020,0))
	end
end
function c47550020.attackup(e,c)
	return c:GetCounter(0x55d0)*500
end
function c47550020.dacon(e)
	return e:GetHandler():GetCounter(0x55d0)>3
end
function c47550020.negcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return ep~=tp
		and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
end
function c47550020.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local ct=Duel.GetOperatedGroup():GetFirst()
	e:SetLabelObject(ct)
end
function c47550020.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() then
		if e:GetLabelObject():IsRace(RACE_WARRIOR) then
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,re:GetHandler(),1,0,0)
		elseif e:GetLabelObject():IsRace(RACE_SPELLCASTER) then
			Duel.SetOperationInfo(0,CATEGORY_REMOVE,re:GetHandler(),1,0,0)  
		end
	end
end
function c47550020.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		if e:GetLabelObject():IsRace(RACE_WARRIOR) then
			Duel.Destroy(eg,REASON_EFFECT)
		elseif e:GetLabelObject():IsRace(RACE_SPELLCASTER) then
			Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
		end
		Duel.Hint(HINT_SOUND,0,aux.Stringid(47550020,1))
	end
end
function c47550020.atksuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SOUND,0,aux.Stringid(47550020,2))
end