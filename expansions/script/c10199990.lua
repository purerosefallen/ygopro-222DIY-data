--我靠卡
local m=10199990
local cm=_G["c"..m]
if not RSVAL then
   RSVAL=RSVAL or {}
   rsv=RSVAL
   RESETFE = RESET_EVENT+0x1fe0000

-------------#########Utoland Quick Effect#####-----------------
function rsv.UtolandSpecialOrPlaceBool(tp,rc)
	local szone1,szone2=0,1
	if rc and rc:IsLocation(LOCATION_SZONE) then
	   szone1= rc and -1 or 0
	   szone2= rc and 0 or 1
	end
	local b1=(not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetMZoneCount(tp,rc)>1 and Duel.IsPlayerCanSpecialSummonMonster(tp,10122011,0xc333,0x4011,0,0,1,RACE_SPELLCASTER,ATTRIBUTE_DARK))
	local b2=(Duel.IsPlayerAffectedByEffect(tp,10122021) and Duel.GetLocationCount(tp,LOCATION_SZONE)>szone2)
	local a1=(Duel.GetMZoneCount(tp,rc)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,10122011,0xc333,0x4011,0,0,1,RACE_SPELLCASTER,ATTRIBUTE_DARK))
	local a2=(Duel.IsPlayerAffectedByEffect(tp,10122021) and Duel.GetLocationCount(tp,LOCATION_SZONE)>szone1)
	local b3=(a1 and a2)
	return b1,b2,b3,a1,a2
end
function rsv.UtolandGraveDestroyActivateEffect(c,code)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10122001,8))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,0x1e0+TIMING_CHAIN_END)
	e1:SetCountLimit(1,code)
	e1:SetLabel(code)
	e1:SetTarget(rsv.utolandgdtg)
	e1:SetOperation(rsv.utolandgdop)
	c:RegisterEffect(e1)
end
function rsv.utolandgdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if chkc then return false end
	if chk==0 then return tc and tc:IsCanBeEffectTarget(e) and e:GetHandler():GetActivateEffect():IsActivatable(tp) end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,tp,LOCATION_FZONE)
end
function rsv.utolandgdop(e,tp,eg,ep,ev,re,r,rp)
	local tc,c=Duel.GetFirstTarget(),e:GetHandler()
	local te=tc:GetActivateEffect()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and te:IsActivatable(tp) then
	   Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	   local tep=tc:GetControler()
	   local cost=te:GetCost()
	   if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	   Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
function rsv.UtolandToHandActivateEffect(c,code)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10122001,8))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0+TIMING_CHAIN_END)
	e1:SetCountLimit(1,code)
	e1:SetLabel(code)
	e1:SetCost(rsv.utolandthcost)
	e1:SetTarget(rsv.utolandthtg)
	e1:SetOperation(rsv.utolandthop)
	c:RegisterEffect(e1)
end
function rsv.utolandthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(rsv.utolandthfilter,tp,LOCATION_HAND,0,1,nil,tp,e:GetLabel()) end
end
function rsv.utolandthfilter(c,tp,code)
	if not c:IsType(TYPE_FIELD) or c:IsCode(code) then return false end
	local te=c:GetActivateEffect()
	--for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_ACTIVATE)}) do
		--local con,val=pe:GetCondition(),pe:GetValue()
		--if (not con or con(pe)) and val(pe,te,1-tp) then return false end
	--end
	--return not c:IsHasEffect(EFFECT_CANNOT_TRIGGER) and not c:IsHasEffect(EFFECT_CANNOT_ACTIVATE)
	return te:IsActivatable(tp,true)
end
function rsv.utolandthop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10122001,7))
	local tc=Duel.SelectMatchingCard(tp,rsv.utolandthfilter,tp,LOCATION_HAND,0,1,1,nil,tp,e:GetLabel()):GetFirst()
	if tc then
	   local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	   if fc then
		  Duel.SendtoGrave(fc,REASON_RULE)
		  Duel.BreakEffect()
	   end
	   Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	   local te=tc:GetActivateEffect()
	   local tep=tc:GetControler()
	   local cost=te:GetCost()
	   if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	   Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
function rsv.utolandthcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHandAsCost() end
	Duel.SendtoHand(c,nil,REASON_COST)
end
function rsv.UtolandTokenTg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsPlayerCanSpecialSummonMonster(tp,10122011,0xc333,0x4011,0,0,1,RACE_SPELLCASTER,ATTRIBUTE_DARK)) or (Duel.IsPlayerAffectedByEffect(tp,10122021) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0) end
	   Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	   Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function rsv.UtolandTokenOp(op,ignore)
	return function(e,tp,eg,ep,ev,re,r,rp)
	   local c=e:GetHandler()
	   if (not ignore and not c:IsRelateToEffect(e)) then return end
	   local b1=(Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,10122011,0xc333,0x4011,0,0,1,RACE_SPELLCASTER,ATTRIBUTE_DARK))
	   local b2=(Duel.IsPlayerAffectedByEffect(tp,10122021) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
	   if not b1 and not b2 then return end
	   local token=Duel.CreateToken(tp,10122011)
	   if b1 and (not b2 or not Duel.SelectYesNo(tp,aux.Stringid(10122021,0))) then
		  if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)<=0 then return end
	   else
		  if Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
			 local e1=Effect.CreateEffect(c)
			 e1:SetCode(EFFECT_CHANGE_TYPE)
			 e1:SetType(EFFECT_TYPE_SINGLE)
			 e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			 e1:SetReset(RESET_EVENT+0x1fc0000)
			 e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			 token:RegisterEffect(e1,true)
			 rsv.UtolandTokenSpellOp(c,token)
		  else return
		  end
	   end
	   op({e:GetHandler(),token},e)
	end 
end
function rsv.UtolandTokenSpellOp(c,tc)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetRange(LOCATION_SZONE)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetReset(RESETFE)
	e0:SetDescription(aux.Stringid(10122001,1))
	e0:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e0:SetTarget(function(e,sc)
	   return e:GetHandler():GetColumnGroup():Filter(Card.IsControler,nil,tp):IsContains(sc)
	end)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetValue(aux.indoval)
	tc:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetCode(EFFECT_UNRELEASABLE_SUM)
	e1:SetValue(function(e,re,rp)
	   return rp==1-e:GetHandlerPlayer()
	end)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	tc:RegisterEffect(e2)   
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetReset(RESETFE)
	e3:SetCondition(function(e,tp)
	   return Duel.GetTurnPlayer()==tp
	end)
	e3:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
	   if chk==0 then return e:GetHandler():GetColumnGroup():Filter(Card.IsControler,nil,1-tp):FilterCount(Card.IsAbleToRemove,nil)>0 end
	end)
	e3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
	   local g=e:GetHandler():GetColumnGroup():Filter(Card.IsControler,nil,1-tp):Filter(Card.IsAbleToRemove,nil)  
	   if g:GetCount()>0 then
		  Duel.Hint(HINT_CARD,0,10122011)
		  Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	   end  
	end)
	tc:RegisterEffect(e3)
end
-------------#########Diablo Quick Effect[NEW]#####-----------------
function rsv.DiabloAngelHandXyzEffect(sc,bool)
	local e1=Effect.CreateEffect(sc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(10121011)
	sc:RegisterEffect(e1)
	if not bool then
	   local e2=Effect.CreateEffect(sc)
	   e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	   e2:SetType(EFFECT_TYPE_SINGLE)
	   e2:SetRange(LOCATION_DECK)
	   e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	   sc:RegisterEffect(e2)
	end
	return e1
end
function rsv.DiabloDMSpecialSummonEffect(sc,mcode,bool)
	local e1=Effect.CreateEffect(sc)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC) 
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,mcode)
	e1:SetCondition(function(e,c)
	   if c==nil then return true end
	   if c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
	   return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.CheckRemoveOverlayCard(c:GetControler(),1,0,2,REASON_COST)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp,c)
	   Duel.RemoveOverlayCard(tp,1,0,2,2,REASON_COST)
	end)
	sc:RegisterEffect(e1)
	if not bool then 
	   local e2=Effect.CreateEffect(sc)
	   e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	   e2:SetType(EFFECT_TYPE_SINGLE)
	   e2:SetRange(LOCATION_DECK)
	   e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	   sc:RegisterEffect(e2)
	end
	return e1
end
function rsv.DiabloXyzEffect(sc,ct)
	local e1=Effect.CreateEffect(sc)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(rsv.DiabloXyzCon(ct))
	e1:SetTarget(rsv.DiabloXyzTg(ct))
	e1:SetOperation(rsv.DiabloXyzOp(ct))
	e1:SetValue(SUMMON_TYPE_XYZ)
	sc:RegisterEffect(e1)
end
function rsv.DiabloXyzMaterialFilter(c,xyzc,f,tp,og)
	return (c:IsHasEffect(10121011) or c:IsLocation(LOCATION_MZONE)) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsCanBeXyzMaterial(xyzc) and (c:IsControler(tp) or c:IsHasEffect(10121010) or (og and og:IsContains(c)))
end
function rsv.DiabloXyzMaterialFilterog(c,xyzc,f)
	if c:IsLocation(LOCATION_REMOVED+LOCATION_ONFIELD) and c:IsFacedown() then return false end
	return c:IsCanBeXyzMaterial(xyzc) 
end
function rsv.DiabloXyzCheckControler(c,tp,og)
	return (not og or not og:IsContains(c)) and c:IsControler(1-tp) and c:IsHasEffect(10121010)
end
function rsv.DiabloXyzGroupFilter(g,xyzc,minct,tp,og)
	local oct=g:FilterCount(rsv.DiabloXyzCheckControler,nil,tp,og)
	if oct>1 then return false end
	if g:IsExists(Card.IsHasEffect,1,nil,10121003) then return true end 
	local ct=g:GetCount()
	return g:FilterCount(Card.IsXyzLevel,nil,xyzc,10)==ct-oct and ct>=minct
end
function rsv.DiabloXyzLevelFreeCheck(c,tp,xyzc,mg,sg,gf,minc,maxc,minct,og)
	sg:AddCard(c)
	local ct=sg:GetCount()
	local res=(ct>=minc and rsv.DiabloXyzLevelFreeGoal(sg,tp,xyzc,gf,minct,og)) or (ct<maxc and mg:IsExists(rsv.DiabloXyzLevelFreeCheck,1,sg,tp,xyzc,mg,sg,gf,minc,maxc,minct,og))
	sg:RemoveCard(c)
	return res
end
function rsv.DiabloXyzLevelFreeGoal(g,tp,xyzc,gf,minct,og)
	if g:IsExists(Auxiliary.TuneMagicianCheckX,1,nil,g,EFFECT_TUNE_MAGICIAN_X) then return false end
	return (not gf or gf(g,xyzc,minct,tp,og)) and Duel.GetLocationCountFromEx(tp,tp,g,xyzc)>0
end
function rsv.DiabloXyzCon(minct)
	return  function(e,c,og,min,max)
			if c==nil then return true end  
			if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
			local tp=c:GetControler()
			local f=nil
			local gf=rsv.DiabloXyzGroupFilter
			local minc=math.ceil(minct/2)
			local maxc=999
			if min then
			   minc=math.max(minc,min)
			   maxc=math.min(maxc,max)
			end
			if maxc<minc then return false end
			local mg=nil
			if og then
			   mg=og:Filter(rsv.DiabloXyzMaterialFilterog,nil,c,f)
			else
			   mg=Duel.GetMatchingGroup(rsv.DiabloXyzMaterialFilter,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c,f,tp,og)
			end
			local sg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_XMATERIAL)
			if sg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
			local ct=sg:GetCount()
			if ct>maxc then return false end
			return (ct>=minc and rsv.DiabloXyzLevelFreeGoal(sg,tp,c,gf,minct,og)) or mg:IsExists(rsv.DiabloXyzLevelFreeCheck,1,sg,tp,c,mg,sg,gf,minc,maxc,minct,og)
	 end
end
function rsv.DiabloXyzTg(minct)
	   return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if og and not min then
					return true
				end
				local f=nil
				local gf=rsv.DiabloXyzGroupFilter
				local minc=math.ceil(minct/2)
				local maxc=999
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local mg=nil
				if og then
					mg=og:Filter(rsv.DiabloXyzMaterialFilterog,nil,c,f)
				else
					mg=Duel.GetMatchingGroup(rsv.DiabloXyzMaterialFilter,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c,f,tp,og)
				end
				local g=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_XMATERIAL)
				local ct=g:GetCount()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				g:Select(tp,ct,ct,nil)
				local ag=mg:Filter(rsv.DiabloXyzLevelFreeCheck,g,tp,c,mg,g,gf,minc,maxc,minct,og)
				while ct<maxc and ag:GetCount()>0 do
					local minsct=1
					local finish=(ct>=minc and rsv.DiabloXyzLevelFreeGoal(g,tp,c,gf,minct,og))
					if finish then
						minsct=0
					end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
					local tg=ag:Select(tp,minsct,1,nil)
					if tg:GetCount()==0 then break end
					g:Merge(tg)
					ct=g:GetCount()
					ag=mg:Filter(rsv.DiabloXyzLevelFreeCheck,g,tp,c,mg,g,gf,minc,maxc,minct,og)
				end
				if g:GetCount()>0 then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
	   end
end
function rsv.DiabloXyzOp(minct)
	   return  function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
			   if og and not min then
				  local sg=Group.CreateGroup()
				  local tc=og:GetFirst()
				  while tc do
						local sg1=tc:GetOverlayGroup()
						sg:Merge(sg1)
				  tc=og:GetNext()
				  end
				  Duel.SendtoGrave(sg,REASON_RULE)
				  c:SetMaterial(og)
				  Duel.Overlay(c,og)
				else
				  local mg=e:GetLabelObject()
				  if e:GetLabel()==1 then
					 local mg2=mg:GetFirst():GetOverlayGroup()
					 if mg2:GetCount()~=0 then
						Duel.Overlay(c,mg2)
					 end
				  else
					 local sg=Group.CreateGroup()
					 local tc=mg:GetFirst()
					 while tc do
						   local sg1=tc:GetOverlayGroup()
						   sg:Merge(sg1)
					 tc=mg:GetNext()
					 end
					 if c10121010.exmaterial then
						Duel.Overlay(c,sg)
					 else
						Duel.SendtoGrave(sg,REASON_RULE)
					 end
				  end
				  c:SetMaterial(mg)
				  local handm,exgm=mg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND),mg:IsExists(rsv.DiabloXyzCheckControler,1,nil,tp,og)
				  Duel.Overlay(c,mg)
				  if handm then Duel.ShuffleHand(tp) end
				  if exgm then Duel.RegisterFlagEffect(tp,10121010,RESET_PHASE+PHASE_END,0,1) end
				  mg:DeleteGroup()
				end
		 end
end
-------------#########Diablo Quick Effect[OLD]#####-----------------
function rsv.DiabloAngelSpecialSummonEffect(c,code,econ,eop)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(econ)
	if eop then
	   e1:SetOperation(eop)
	end
	c:RegisterEffect(e1) 
	rsv.SingleValEffect(c,code,nil,EFFECT_INDESTRUCTABLE_EFFECT,rsv.diabloangelval)
	rsv.SingleSpecialSummonSucessEffect(c,code,0,nil,EFFECT_TYPE_TRIGGER_F,CATEGORY_DESTROY,nil,nil,nil,rsv.diabloangeltg,rsv.diabloangelop)
end
function rsv.diabloangelval(e,re)
	return re:IsActiveType(TYPE_EFFECT) and re:GetHandler():IsRace(RACE_FIEND)
end 
function rsv.diabloangeltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(rsv.diabloangelfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),tp,LOCATION_MZONE)
end
function rsv.diabloangelop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(rsv.diabloangelfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
function rsv.diabloangelfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_FIEND)
end
function rsv.DiabloAngelToGraveEffect(c,code,cate,flag,etg,eop)
	local flag2=0 or flag
	rsv.SingleToGraveEffect(c,code,1,nil,EFFECT_TYPE_TRIGGER_O,cate,flag2+EFFECT_FLAG_DELAY,nil,nil,etg,eop)
end
function rsv.DiabloSpecialSummonEffect(c,code)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_DESTROY_REPLACE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
	   if chk==0 then return not e:GetHandler():IsReason(REASON_REPLACE) and e:GetHandler():IsOnField() and e:GetHandler():IsFaceup() and Duel.IsExistingMatchingCard(rsv.diablorepfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,e:GetHandler(),e) end
		 if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
			local g=Duel.SelectMatchingCard(tp,rsv.diablorepfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,e:GetHandler(),e)
			e:SetLabelObject(g:GetFirst())
			g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		 return true
		 else return false 
		 end
	 end)
	 e0:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		 local tc=e:GetLabelObject()
		 Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCodeRule())
		 Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(10121001,2))
		 tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
		 Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
	 end)
	 c:RegisterEffect(e0)
	 local e1=Effect.CreateEffect(c)
	 e1:SetDescription(aux.Stringid(10121001,0))
	 e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	 e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	 e1:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	 e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CHAIN_UNIQUE)
	 e1:SetCode(EVENT_DESTROYED)
	 e1:SetCountLimit(1,code)
	 e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return eg:IsExists(rsv.diablodesfilter,1,nil) and not eg:IsContains(c)
	 end)
	 e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
	   if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	   local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	   Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_GRAVE+LOCATION_HAND)
	   Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),tp,LOCATION_MZONE)
	 end)
	 e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
	   if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		  local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,c)
		  if g:GetCount()>0 then
			 Duel.BreakEffect()
			 Duel.Destroy(g,REASON_EFFECT)
		  end
	   end
	 end)
	 c:RegisterEffect(e1)
end
function rsv.diablodesfilter(c)
	local prc=c:GetPreviousRaceOnField()
	return c:IsRace(RACE_FAIRY+RACE_FIEND) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(0x47) and (not c:IsPreviousLocation(LOCATION_MZONE) or (bit.band(prc,RACE_FIEND)~=0 or bit.band(prc,RACE_FAIRY)~=0) or tc:IsPreviousPosition(POS_FACEDOWN))
end
function rsv.diablorepfilter(c,e)
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsRace(RACE_FIEND) and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function rsv.DiabloSSummonSucessEffect(c,code,cate,flag,etg,eop)
	local eflag,ecate=0,0
	if flag then eflag=flag end
	if cate then ecate=cate end
	rsv.SingleSpecialSummonSucessEffect(c,code,1,nil,EFFECT_TYPE_TRIGGER_O,ecate+CATEGORY_COUNTER,eflag+EFFECT_FLAG_DELAY,nil,nil,etg,eop)
end
function rsv.DiabloAddCountSingleEffect(tp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10121001,2)) then
	   Duel.BreakEffect()
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	   local cg=g:Select(tp,1,1,nil)
	   Duel.HintSelection(cg)
	   cg:GetFirst():AddCounter(0x1333,1)
	end
end
--[[---------######Extra Material Link Quick Effect#####------------
--is not use now
function rsv.ExtraMaterialLinkProc(c,f,minct,maxct,gf,exmf)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(rsv.ExmLinkCondition(f,minct,maxct,gf,exmf))
	e1:SetTarget(rsv.ExmLinkTarget(f,minct,maxct,gf,exmf))
	e1:SetOperation(rsv.ExmLinkOperation(f,minct,maxct,gf,exmf))
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1) 
	return e1
end
function rsv.ExmLinkCondition(f,minc,maxc,gf,exmf)
	return  function(e,c)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local mg=Duel.GetMatchingGroup(Auxiliary.LConditionFilter,tp,LOCATION_MZONE,0,nil,f,c)
				local mg2=exmf(tp):Filter(Card.IsCanBeLinkMaterial,nil,c)
				if mg2:GetCount()>0 then
				   mg:Merge(mg2)
				end
				local sg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
				if sg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
				local ct=sg:GetCount()
				if ct>maxc then return false end
				return Auxiliary.LCheckGoal(tp,sg,c,minc,ct,gf)
					or mg:IsExists(Auxiliary.LCheckRecursive,1,sg,tp,sg,mg,c,ct,minc,maxc,gf)
			end
end
function rsv.ExmLinkTarget(f,minc,maxc,gf,exmf)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c)
				local mg=Duel.GetMatchingGroup(Auxiliary.LConditionFilter,tp,LOCATION_MZONE,0,nil,f,c)
				local mg2=exmf(tp):Filter(Card.IsCanBeLinkMaterial,nil,c)
				if mg2:GetCount()>0 then
				   mg:Merge(mg2)
				end
				local bg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
				if #bg>0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
					bg:Select(tp,#bg,#bg,nil)
				end
				local sg=Group.CreateGroup()
				sg:Merge(bg)
				local finish=false
				while #sg<maxc do
					finish=Auxiliary.LCheckGoal(tp,sg,c,minc,#sg,gf)
					local cg=mg:Filter(Auxiliary.LCheckRecursive,sg,tp,sg,mg,c,#sg,minc,maxc,gf)
					if #cg==0 then break end
					local cancel=not finish
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
					local tc=cg:SelectUnselect(sg,tp,finish,cancel,minc,maxc)
					if not tc then break end
					if not bg:IsContains(tc) then
						if not sg:IsContains(tc) then
							sg:AddCard(tc)
							if #sg==maxc then finish=true end
						else
							sg:RemoveCard(tc)
						end
					elseif #bg>0 and #sg<=#bg then
						return false
					end
				end
				if finish then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else return false end
			end
end
function rsv.ExmLinkOperation(f,min,max,gf)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
				g:DeleteGroup()
			end
end--]]
-------------#########Main Quick Effect#####-----------------
function rsv.ActivateEffect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetDescription(aux.Stringid(m,1))	
	c:RegisterEffect(e1)
	return e1
end   
function rsv.SingleValEffect(ctable,code,ehint,ecode,eval,econ,ereset,elimit)
	local tc1,tc2=nil
	if type(ctable)=="table" then
	   tc1=ctable[1]
	   tc2=ctable[2]
	else
	   tc1,tc2=ctable,ctable
	end
	local e1=Effect.CreateEffect(tc1)
	local pro=EFFECT_FLAG_SINGLE_RANGE
	if ehint then 
	   pro=pro+EFFECT_FLAG_CLIENT_HINT
	   e1:SetDescription(aux.Stringid(code,ehint))
	end
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(pro)
	e1:SetCode(ecode)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(eval)
	rsv.EffectSet(e1,elimit,nil,nil,econ,nil,nil,nil,ereset,ehint)
	tc2:RegisterEffect(e1) 
	return e1
end
function rsv.SingleSpecialSummonSucessEffect(c,code,descint,cltlb,etype,cate,flag,econ,ecost,etg,eop)
	local e1=rsv.SingelTriggerEffect(c,code,descint,cltlb,etype,cate,flag,EVENT_SPSUMMON_SUCCESS,econ,ecost,etg,eop)
	return e1
end
function rsv.SingleToGraveEffect(c,code,descint,cltlb,etype,cate,flag,econ,ecost,etg,eop)
	local e1=rsv.SingelTriggerEffect(c,code,descint,cltlb,etype,cate,flag,EVENT_TO_GRAVE,econ,ecost,etg,eop)
	return e1
end
function rsv.SingelTriggerEffect(c,code,descint,cltlb,etype,cate,flag,ecode,econ,ecost,etg,eop)
	local e1=Effect.CreateEffect(c)
	if desc then
	   e1:SetDescription(aux.Stringid(code,descint))
	end
	rsv.EffectSet(e1,cltlb,cate,flag,econ,ecost,etg,eop,ereset)
	e1:SetType(EFFECT_TYPE_SINGLE+etype)
	e1:SetCode(ecode)
	c:RegisterEffect(e1)
	return e1
end
-------------#########Main Base Effect#####-----------------
function rsv.EffectSet(e1,cltlb,cate,flag,econ,ecost,etg,eop,ereset)
	if cltlb then
	   if type(cltlb)=="table" then
		  if #cltlb==1 then
			 e1:SetCountLimit(cltlb[1])
		  else
			 e1:SetCountLimit(cltlb[1],cltlb[2])
		  end
	   else
		  e1:SetCountLimit(cltlb)
	   end
	end
	if cate then 
	   e1:SetCategory(cate)
	end
	if econ then
	   e1:SetCondition(econ)
	end
	if flag then
	   e1:SetProperty(flag)
	end
	if econ then
	   e1:SetCondition(econ)
	end
	if ecost then
	   e1:SetCondition(ecost)
	end
	if etg then
	   e1:SetTarget(etg)
	end
	if eop then
	   e1:SetOperation(eop)
	end
	if ereset then
	   e1:SetReset(ereset)
	end
end
-------------#########Quick Cost###########-----------------
function rsv.costrmxyzm(ct)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		 if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,ct,REASON_COST) end
		 e:GetHandler():RemoveOverlayCard(tp,ct,ct,REASON_COST)
	end
end
-------------#########Quick Condition#######-----------------
--Condition in Main Phase
function rsv.conmp(e)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
-------------#########RSV Special Edition#####-----------------

-------------------E-----N-----D--------------------------
end
------------########################-----------------
if cm then
function cm.initial_effect(c)
	
end
end